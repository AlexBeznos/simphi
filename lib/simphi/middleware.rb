require 'simphi/request'

module Simphi
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Simphi::Request.new(env)
      request.normalize_hash_params

      status, headers, response = @app.call(request.env)
      [status, headers, response]
    end
  end
end
