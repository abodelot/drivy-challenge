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
      )
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

  describe '#price' do
    it 'should compute total price' do
      # day 1: 2000
      # day 2-3: 1800
      # distance: 1000
      expect(@rental.price).to eq(6600)
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
end
