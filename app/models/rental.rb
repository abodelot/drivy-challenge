class Rental < ActiveRecord::Base
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
  # the number of rental days multiplied by the car's price per day
  #
  def time_price
    car.price_per_day * days
  end

  ##
  # Price distance component:
  # the number of km multiplied by the car's price per km
  #
  def distance_price
    distance * car.price_per_km
  end

  private

  def valid_rental_dates?
    if start_date > end_date
      errors.add(:end_date, 'must be after start date')
    end
  end
end
