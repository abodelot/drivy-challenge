require 'json'
require 'active_record'

require_relative 'lib/action_exporter'
require_relative 'models/car'
require_relative 'models/rental'
require_relative 'models/option'
require_relative 'models/option/additional_insurance'
require_relative 'models/option/baby_seat'
require_relative 'models/option/gps'

module Drivy
  path = File.dirname(__FILE__) + '/config/database.yml'
  db_config = YAML::safe_load(File.open(path))
  ActiveRecord::Base.establish_connection(db_config)

  class << self
    include ActionExporter

    def rentals
      {
        rentals: Rental.order(:id).map do |rental|
          {
            id: rental.id,
            options: rental.options.map(&:name),
            actions: generate_actions_from_rental(rental)
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
      Option.delete_all
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
