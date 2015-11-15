require "simphi/middleware"
require "spec_helper"

describe Simphi::Middleware do
  let(:env) { env_for('http://any-fake-domain.com') }
  let(:app) { -> (env) { [200, env, "app"] } }
  let!(:middleware) do
    Simphi::Middleware.new(app)
  end

  context 'uses simphi/request by' do
    after do
      middleware.call(env)
    end

    it 'instantiate Simphi::Request' do
      expect(Simphi::Request).to receive(:new).and_return(Simphi::Request.new(env))
    end

    it '#normalize_hash_params call' do
      expect_any_instance_of(Simphi::Request).to receive(:normalize_hash_params)
    end
  end

  def env_for url, opts={}
    Rack::MockRequest.env_for(url, opts)
  end
end
