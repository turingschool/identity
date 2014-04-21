require 'json'
require 'cgi'

module Jsl
  module Identity
    class UserRepository
      # e.g. 2014-04-18 21:14:16 UTC
      # comes from https://github.com/rails/rails/blob/5f72fc6af8ad19df2b4e4f442b9ab17dd6846f46/activesupport/lib/active_support/time_with_zone.rb#L196
      TIME_FORMAT      = "%Y/%m/%d %H:%M:%S %Z".freeze
      OK_STATUS        = 200
      NOT_FOUND_STATUS = 404

      def initialize(attributes)
        self.web_client = attributes.fetch :web_client
        self.base_url   = attributes.fetch :base_url # this url stuff should maybe move down into the clients, or maybe into a separate obj, not sure, we'll wait until more than one class needs it
      end

      def login_url(return_url)
        url_for '/login', return_url: return_url
      end

      def find(user_id)
        url                 = url_for "/api/users/#{user_id}"
        result              = web_client.get url
        case result.status
        when OK_STATUS
          raw_user_attributes = JSON.parse result.body
          user_attributes     = convert_types raw_user_attributes
          User.new user_attributes
        when NOT_FOUND_STATUS
          raise ResourceNotFound.new(User, url)
        else
          raise "Unexpected status: #{result.status}"
        end
      end

      private

      attr_accessor :web_client, :base_url

      def url_for(path, query_params={})
        base_url + path + to_query_string(query_params)
      end

      # there's only one test on this, IDK why it's not just a method in CGI
      # implementation is half-stolen from Rails, and half just "well this makes sense" :/
      def to_query_string(params)
        return '' if params.empty?
        '?' << params.map { |key, value| "#{CGI.escape key.to_s}=#{CGI.escape value.to_s}" }.join('&')
      end

      def convert_types(raw_user_attributes)
        raw_user_attributes.merge \
          'created_at' => DateTime.strptime(raw_user_attributes.fetch('created_at'), TIME_FORMAT),
          'updated_at' => DateTime.strptime(raw_user_attributes.fetch('updated_at'), TIME_FORMAT)
      end
    end
  end
end
