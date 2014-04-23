require "net/http"
require 'jsl/identity/response'

module Jsl
  module Identity
    module WebClients
      class NetHttp
        def initialize(username, password)
          self.username = username
          self.password = password
        end

        def get(url)
          uri     = URI.parse(url)
          http    = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.request_uri)
          request.basic_auth(username, password)
          response = http.request(request)
          Response.new response.code, response.body
        end

        private

        attr_accessor :username, :password
      end
    end
  end
end
