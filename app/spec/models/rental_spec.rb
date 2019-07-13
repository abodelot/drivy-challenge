require_relative '../spec_helper'

describe Rental do
  before(:each) do
    @rental = Rental.new(
      distance: 100,
      start_date: 3.days.ago,
      end_date: 1.day.ago,
      car: Car.new(
        price_per_day: 2000,
        price_per_km: 10
      ),
      options: [
        Option::AdditionalInsurance.new,
        Option::BabySeat.new,
        Option::Gps.new
      ]
    )
  end

  describe 'validations' do
    it 'should ensure end_date > start_date' do
      expect(@rental).to be_valid

      @rental.end_date = 4.days.ago
      expect(@rental).not_to be_valid
    end
  end

  describe '#days' do
    it 'should compute rental duration in days' do
      expect(@rental.days).to eq 3

      @rental.start_date = 10.days.from_now
      @rental.end_date = 30.days.from_now
      expect(@rental.days).to eq 21
    end

    it 'should return 1 day when start_date equals end_date' do
      @rental.start_date = '2018-06-01'
      @rental.end_date = '2018-06-01'
      expect(@rental.days).to eq 1
    end
  end

  describe '#distance_price' do
    it 'should compute price based on distance' do
      expect(@rental.distance_price).to eq(1000) # 100 * 10

      @rental.distance = 500
      expect(@rental.distance_price).to eq(5000) # 500 * 10

      @rental.car.price_per_km = 40
      expect(@rental.distance_price).to eq(20000) # 500 * 40
    end
  end

  describe '#time_price' do
    it 'should compute price base on time' do
      # day 1: 2000
      # day 2-3: 1800
      expect(@rental.time_price).to eq(5600)

      @rental.end_date = @rental.start_date + 5.days
      # day 1: 2000
      # day 2-4: 1800
      # day 5-6: 1400
      expect(@rental.time_price).to eq(10200)

      @rental.car.price_per_day = 1000
      # day 1: 1000
      # day 2-4: 900
      # day 5-6: 700
      expect(@rental.time_price).to eq(5100)
    end
  end

  describe '#booking_price' do
    it 'should compute booking price based on time and distance' do
      # day 1: 2000
      # day 2-3: 1800
      # distance: 1000
      expect(@rental.booking_price).to eq(6600)
    end

    it 'should equals to price when no options' do
      expect(@rental.booking_price).to be < @rental.price
      @rental.options = []
      expect(@rental.booking_price).to eq(@rental.price)
    end
  end

  describe '#discount' do
    it 'should give 50% discount after 10 days' do
      expect(Rental.discount(11)).to eq 50
      expect(Rental.discount(15)).to eq 50
    end

    it 'should give 30% discount after 4 days' do
      expect(Rental.discount(5)).to eq 30
      expect(Rental.discount(10)).to eq 30
    end

    it 'should give 10% discount after 1 day' do
      expect(Rental.discount(3)).to eq 10
      expect(Rental.discount(2)).to eq 10
    end

    it 'should not give a discount' do
      expect(Rental.discount(1)).to eq 0
      expect(Rental.discount(0)).to eq 0
    end
  end

  describe '#commission' do
    it 'should compute commission' do
      expect(@rental.commission).to eq 1980
      expect(@rental.booking_price * Rental::COMMISSION_PERCENT / 100).to eq 1980
    end

    it 'should be the sum of all fees' do
      expect(@rental.commission).to eq(
        @rental.insurance_fee + @rental.assistance_fee + @rental.drivy_fee
      )
    end
  end

  describe '#insurance_fee' do
    it 'should compute insurance fee' do
      expect(@rental.insurance_fee).to eq 990

      stub_const('Rental::INSURANCE_FEE_COMMISSION_PERCENT', 100)
      expect(@rental.insurance_fee).to eq @rental.commission
    end
  end

  describe '#assistance_fee' do
    it 'should compute assistance fee, based on days' do
      expect(@rental.assistance_fee).to eq 300

      @rental.end_date = @rental.start_date + 5.days
      expect(@rental.assistance_fee).to eq 600

      @rental.end_date = @rental.start_date + 1.day
      expect(@rental.assistance_fee).to eq 200

      stub_const('Rental::ASSISTANCE_FEE_PER_DAY', 300)
      expect(@rental.assistance_fee).to eq 600
    end
  end

  describe '#drivy_fee' do
    it 'should compute drivy fee as the remaining' do
      expect(@rental.drivy_fee).to eq 690
      expect(@rental.drivy_fee).to eq(
        @rental.commission - @rental.insurance_fee - @rental.assistance_fee
      )
    end
  end

  describe '#owner_share' do
    it 'should compute owner share' do
      expect(@rental.owner_share).to eq(
        @rental.price - @rental.commission - @rental.send(:options_price_for, :drivy)
      )
    end
  end

  describe '#drivy_share' do
    it 'should compute drivy share' do
      expect(@rental.drivy_share).to eq(
        @rental.drivy_fee + @rental.send(:options_price_for, :drivy)
      )
    end

    it 'should equals to drivy fee when no options' do
      @rental.options = []
      expect(@rental.drivy_share).to eq @rental.drivy_fee
    end
  end
end
