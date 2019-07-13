# Drivy Backend Challenge

By Alexandre Bodelot.

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

**Note**: the db schema is updated on level5. you must re-run `./tasks/init_schema.rb` if your db has a schema from a previous level.

## Usage:

You can check the generated `output.json` against `expected_output.json` for a given level. Example for level 5:

```
./check.sh 5
```

Running `ruby main.rb` from the level directory also works.

Each level has a dedicated git commit and git tag (from `level1` to `level5`). To a test a previous level, checkout the associated git tag.

**Note**: the level5 test produces an output with an empty array, and formatting is slighly different from `expected_output.json`:

```
<       "options": [
<
<
],
---
>       "options": [],
```

## Testing:

Run unit tests with rspec:

```
bundle exec rspec
```

## Going further / TBD

- Remove all business-related constant values. Better solutions:
    - Configuration files
    - Environment variables
    - Config as data
- Action array (`lib/action_exporter.rb`):
    - What about other actors? Could actions array be generated instead of being hard-coded?
    - Not enough data. KISS.
- `Option` inheritance:
    - All options follow a pricing based on rental days. We could remove inheritance and use `OptionTemplate(type, payee, price_per_day)` + `Option(rental_id, option_template_id)` instead. It would simplify adding/removing/updating options a lot.
    - But it would be less flexible. What if an option pricing is not based on days?
    - Hybrid approach:
        - `Option` base class, `DayBasedOption` child class (gps, baby_seat, additional_insurance are data)
        - Create custom child classes for complex options
- Better testing
    - randomize values
    - linter, code coverage, fixtures...
- Performance:
    - Some values are re-computed a lot! Use [memoization](https://en.wikipedia.org/wiki/Memoization) techniques.
    - Set-up benchmark tests
    - Choose an appropriate data storage
