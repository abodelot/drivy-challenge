require_relative '../app/drivy'

Drivy.populate_db('data/input.json')
Drivy.export_rentals('data/output.json')
