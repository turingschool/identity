require 'jsl/identity/response'

module Jsl
  module Identity
    module WebClients
      class Rack
        # Use like this:
        #   session = Rack::Test::Session.new(Rails.application)
        #   session.basic_authorize 'username', 'password'
        #   client = Jsl::Identity::WebClients::Rack.new session
        #   client.get "/whatever"
        def initialize(session)
          self.session = session
        end

        def get(url)
          response = session.get url
          Response.new response.status, response.body
        end

        def patch(url, attributes)
          response = session.patch url, attributes
          Response.new response.status, response.body
        end

        private

        attr_accessor :session
      end
    end
  end
end
