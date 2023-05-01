# frozen_string_literal: true

# Load necessary libraries
require 'rspec'
require 'flex_uri'

# Configure RSpec settings
RSpec.configure do |config|
  # Enable colors for test output
  config.color = true

  # Display more detailed output
  config.formatter = :documentation

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
