# Drivy Backend Challenge

## Setup

1. Install dependencies:

    ```
    bundle install
    ```

2. Setup database:

    - Copy `config/database.yml.example` to `config/database.yml`.
    - Edit credentials and adapter if needed (default is `postgresql`).
    - Create the database (default is `drivy`)
    - Initialize the db schema: `./tasks/init_schema.rb`

3. Usage

    ```
    require 'drivy'

    Drivy.populate_db('/path/to/file.json')
    Drivy.export_rentals('/path/to/file.json')
    ```

4. Testing:

    Run unit tests with rspec:

    ```
    bundle exec rspec
    ```

    Check `output.json` against `expected_output.json` for a given level:

    ```
    ./check.sh [1:5]
    ```
