require 'json'
require 'active_record'

require_relative 'models/car'
require_relative 'models/rental'

module Drivy
  path = File.dirname(__FILE__) + '/config/database.yml'
  db_config = YAML::safe_load(File.open(path))
  ActiveRecord::Base.establish_connection(db_config)

  class << self
    def rentals
      {
        rentals: Rental.order(:id).map do |rental|
          {
            id: rental.id,
            actions: rental.actions
          }
        end
      }
    end

    def export_rentals(path)
      File.open(path, 'w') do |file|
        file.write(JSON.pretty_generate(rentals))
        file.write("\n") # Extra-line to match expected_output.json
      end
    end

    def populate_db(filepath)
      # Clean-up previous data
      Rental.delete_all
      Car.delete_all

      # Insert data from json file
      data = JSON.load(open(filepath))
      data.each do |tablename, values|
        # 'rentals' => Rental
        model = tablename.singularize.camelcase.constantize
        values.each do |value|
          model.create!(value)
        end
      end
    end
  end
end
