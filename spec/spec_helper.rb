require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'factory_girl_rails'
require 'database_cleaner'

Faker::Config.locale = :en

Capybara.default_selector = :css
Capybara.default_wait_time = 5
Capybara.javascript_driver = :poltergeist
Capybara.ignore_hidden_elements = true

if ENV['COVERAGE'] == 'on'
  require 'simplecov'
  require 'simplecov-rcov'
  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      SimpleCov::Formatter::RcovFormatter.new.format(result)
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start 'rails' do
    add_filter "/vendor/"
  end
end

Rails.logger.level = 0
ActiveRecord::Base.logger = nil

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

include ActionView::Helpers::NumberHelper

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  # config.order = "random"

  config.include Devise::TestHelpers, type: :controller
  config.include Capybara::DSL, type: :request
  config.include Capybara::RSpecMatchers, type: :request
  not_trancation_tables = []

  config.before(:all) do
    Settings.reload!
    FactoryGirl.reload
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :request) do
    DatabaseCleaner.strategy = :truncation, {except: not_trancation_tables}
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation, {except: not_trancation_tables}
  end

  config.before(:each, truncation: true) do
    DatabaseCleaner.strategy = :truncation, {except: not_trancation_tables}
  end

  config.before(:each) do
    I18n.locale = 'ja'
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    connection = ActiveRecord::Base.connection
    not_trancation_tables.each { |table| connection.execute "TRUNCATE #{table}" }
  end

  config.include FactoryGirl::Syntax::Methods
end
