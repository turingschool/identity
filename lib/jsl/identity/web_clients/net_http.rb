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
          http, request = http_and_request_for(url, Net::HTTP::Get)
          response = http.request request
          Response.new response.code, response.body
        end

        def patch(url, attributes)
          url           = "#{url}?#{build_nested_query attributes}"
          http, request = http_and_request_for(url, Net::HTTP::Patch)
          response      = http.request request
          Response.new response.code, response.body
        end

        def post(url, attributes)
          url           = "#{url}?#{build_nested_query attributes}"
          http, request = http_and_request_for(url, Net::HTTP::Post)
          response      = http.request request
          Response.new response.code, response.body
        end

        private

        attr_accessor :username, :password

        def http_and_request_for(url, method_class)
          uri     = URI.parse(url)
          http    = Net::HTTP.new(uri.host, uri.port)

          if uri.scheme == "https"
            http.use_ssl = true
          end

          request = method_class.new(uri.request_uri)
          request.basic_auth(username, password)
          return http, request
        end

        # copy/pasted from https://github.com/rack/rack/blob/ce4a3959a5be68684c447ce68c626d0cc84f8c1a/lib/rack/utils.rb#L153-169
        def build_nested_query(value, prefix = nil)
          case value
          when Array
            value.map { |v|
              build_nested_query(v, "#{prefix}[]")
            }.join("&")
          when Hash
            value.map { |k, v|
              build_nested_query(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k))
            }.join("&")
          when String
            raise ArgumentError, "value must be a Hash" if prefix.nil?
            "#{prefix}=#{escape(value)}"
          else
            prefix
          end
        end

        # URI escapes. (CGI style space to +)
        def escape(s)
          URI.encode_www_form_component(s)
        end
      end
    end
  end
end
