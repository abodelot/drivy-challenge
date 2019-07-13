#!/usr/bin/env ruby

require 'active_record'

config = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(config)

db = ActiveRecord::Base.connection

%i(options rentals cars).each do |tablename|
  if db.table_exists? tablename
    db.drop_table tablename
  end
end

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

db.create_table :options do |t|
  t.integer :rental_id, null: false
  t.string :sti_type, null: false
end

# Can an option be booked twice? If not:
# add_index :options, [:rental_id, :sti_type], unique: true

db.add_foreign_key :options, :rentals
