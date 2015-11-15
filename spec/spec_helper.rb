require "rails/all"
require "nulldb_rspec"
require "active_support"
require "active_support/core_ext"
require "rack/test"
require "rspec/rails"
# require "rails/test_help"

include NullDB::RSpec::NullifiedDatabase

ActiveRecord::Base.establish_connection :adapter => :nulldb
Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = "random"
end
