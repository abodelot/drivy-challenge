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
      expect(@rental.time_price).to eq(6000) # 3 * 2000

      @rental.end_date = @rental.end_date.next_day
      expect(@rental.time_price).to eq(8000) # 4 * 2000

      @rental.car.price_per_day = 1000
      expect(@rental.time_price).to eq(4000) # 4 * 1000
    end
  end

  describe '#price' do
    it 'should compute total price' do
      expect(@rental.price).to eq(7000)
    end
  end
end
