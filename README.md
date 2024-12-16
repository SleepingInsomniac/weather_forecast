# WeatherForecast - Example RoR Application

## System dependencies
- Ruby: Ruby version specified in .ruby-version
- Redis: Developed against Redis version 7.2.6 (homebrew macOS arm)
- SQLite3: Developed against SQLite version 3.47.2 (homebrew macOS arm)

## Configuration
- Configuration options are available in `config/config.yml`
- Sensitive configuration options are stored via Rails credentials:
    `rails credentials:edit`
    The required values are:
    - geocode_key: # obtain a free key at https://geocode.maps.co

## Getting started
1. Install the prerequisites (macOS):
    - `brew install redis sqlite`

2. Start the redis service:
    - `brew services start redis`

3. Install dependencies:
    - `bundle`

4. Obtain an API key from https://geocode.maps.co
    - run `rails credentials:edit` and add `geocode_key: <your api key>`

4. Initialize the database:
    - `rails db:setup`
    - `RAILS_ENV=test rails db:setup` # If the test env is not initialized

5. Run the test suite:
    - `rspec`

6. Start the development server:
    - `./bin/dev`
    - visit http://localhost:3000

## Documentation

Documentation is written inline with YARD syntax: https://rubydoc.info/gems/yard/file/README.md
Generate documentation by running `yard`

## Testing

Tests are written in RSpec and use webmocks and VCR for external API testing
