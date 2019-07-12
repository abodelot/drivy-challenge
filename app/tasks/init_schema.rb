#!/usr/bin/env ruby

require 'active_record'

config = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(config)

db = ActiveRecord::Base.connection
db.create_table :cars do |t|
  t.integer :price_per_day, null: false
  t.integer :price_per_km, null: false
end

db.create_table :rentals do |t|
  t.integer :car_id, null: false
  t.datetime :start_date, null: false
  t.datetime :end_date, null: false
  t.integer :distance, null: false
end

db.add_foreign_key :rentals, :cars
