class Car < ActiveRecord::Base
  has_many :rentals

  validates :price_per_km, numericality: { greater_than: 0 }
  validates :price_per_day, numericality: { greater_than: 0 }
end
