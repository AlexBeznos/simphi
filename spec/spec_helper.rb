require "simphi/middleware"
require "rack/test"
require "active_support"
require "active_support/core_ext"
# Dir["spec/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = "random"
end
