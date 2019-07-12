class Rental < ActiveRecord::Base
  COMMISSION_PERCENT = 30

  # half of commission goes to the insurance
  INSURANCE_FEE_COMMISSION_PERCENT = 50

  # 1 EUR per day goes the roadside assistance
  ASSISTANCE_FEE_PER_DAY = 100 # (100 cts)

  DISCOUNTS = [
    # [required days for discount, discount percent]
    [10, 50],
    [4, 30],
    [1, 10],
  ]

  belongs_to :car

  validates :distance, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :valid_rental_dates?

  ##
  # The rental duration in days
  #
  def days
    # +1 because end_date is included in the duration range
    ((end_date - start_date) / 3600 / 24).to_i + 1
  end

  ##
  # The total price billed to the driver
  #
  def price
    (time_price + distance_price).to_i
  end

  ##
  # Price time component:
  # price_per_day * number of days, but price_per_day decreases by X% after Y days
  #
  def time_price
    (1..days).map { |x|
      car.price_per_day * (1 - Rental.discount(x) / 100.0)
    }.sum.to_i
  end

  ##
  # Price distance component:
  # the number of km multiplied by the car's price per km
  #
  def distance_price
    distance * car.price_per_km
  end

  ##
  # Get discount percent for given number of days
  # @return int [0..100]
  #
  def self.discount(nb_days)
    DISCOUNTS.each do |min_days, percent|
      if nb_days > min_days
        return percent
      end
    end
    return 0
  end

  def commission
    price * COMMISSION_PERCENT / 100.0
  end

  def owner_share
    (price - commission).round
  end

  def insurance_fee
    (commission * INSURANCE_FEE_COMMISSION_PERCENT / 100).round
  end

  def assistance_fee
    days * ASSISTANCE_FEE_PER_DAY
  end

  def drivy_fee
    (commission - insurance_fee - assistance_fee).round
  end

  def actions
    [
      {
        who: :driver,
        type: :debit,
        amount: price
      },
      {
        who: :owner,
        type: :credit,
        amount: owner_share
      },
      {
        who: :insurance,
        type: :credit,
        amount: insurance_fee
      },
      {
        who: :assistance,
        type: :credit,
        amount: assistance_fee
      },
      {
        who: :drivy,
        type: :credit,
        amount: drivy_fee
      }
    ]
  end

  private

  def valid_rental_dates?
    if start_date > end_date
      errors.add(:end_date, 'must be after start date')
    end
  end
end
