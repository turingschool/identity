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
          @session = session
        end

        def get(url)
          response = @session.get url
          Response.new response.status, response.body
        end
      end
    end
  end
end
