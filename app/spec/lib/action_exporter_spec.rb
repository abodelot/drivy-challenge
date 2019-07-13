require_relative '../spec_helper'

describe ActionExporter do
  include described_class

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

  describe '#generate_actions_from_rental' do
    before(:each) do
      @actions = generate_actions_from_rental(@rental)
    end

    it 'should be a zero-sum game' do
      credits = @actions
        .select { |action| action[:type] == :credit }
        .pluck(:amount)
        .sum

      debits = @actions
        .select { |action| action[:type] == :debit }
        .pluck(:amount)
        .sum

      expect(credits).to eq @rental.price
      expect(credits).to eq debits
    end

    it 'should debit price from driver' do
      action = @actions.find { |action| action[:who] == :driver }
      expect(action[:type]).to eq :debit
      expect(action[:amount]).to eq @rental.price
    end
  end
end

