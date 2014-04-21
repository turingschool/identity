require 'rest-client'
module Jsl
  module Identity
    module WebClients
      class RestClient
        def initialize(username, password)
          self.username = username
          self.password = password
        end

        def get(url)
          ::RestClient::Request.execute method:   :get,
                                        url:      url,
                                        user:     username,
                                        password: password
        end

        private

        attr_accessor :username, :password
      end
    end
  end
end
