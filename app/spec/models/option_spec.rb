require_relative '../spec_helper'

describe Option do
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

  describe Option::AdditionalInsurance do
    before(:each) do
      @option = Option::AdditionalInsurance.new(rental: @rental)
    end

    it 'should compute price base on number of days' do
      expect(@option.price).to eq 3000

      stub_const('Option::AdditionalInsurance::COST_PER_DAY', 2000)
      expect(@option.price).to eq 6000
    end
  end

  describe Option::BabySeat do
    before(:each) do
      @option = Option::BabySeat.new(rental: @rental)
    end

    it 'should compute price based on number of days' do
      expect(@option.price).to eq 600

      stub_const('Option::BabySeat::COST_PER_DAY', 2000)
      expect(@option.price).to eq 6000
    end
  end

  describe Option::Gps do
    before(:each) do
      @option = Option::Gps.new(rental: @rental)
    end

    it 'should compute price based on number of days' do
      expect(@option.price).to eq 1500

      stub_const('Option::Gps::COST_PER_DAY', 2000)
      expect(@option.price).to eq 6000
    end
  end
end
