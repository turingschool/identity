require 'json'
require 'cgi'

module Jsl
  module Identity
    class UserRepository
      # e.g. 2014-04-18 21:14:16 UTC
      # comes from https://github.com/rails/rails/blob/5f72fc6af8ad19df2b4e4f442b9ab17dd6846f46/activesupport/lib/active_support/time_with_zone.rb#L196
      TIME_FORMAT         = "%Y/%m/%d %H:%M:%S %Z".freeze
      OK_STATUS           = 200
      NOT_FOUND_STATUS    = 404
      UNAUTHORIZED_STATUS = 401

      def initialize(attributes)
        self.web_client = attributes.fetch :web_client
        self.base_url   = attributes.fetch :base_url # this url stuff should maybe move down into the clients, or maybe into a separate obj, not sure, we'll wait until more than one class needs it
      end

      def login_url(return_url)
        url_for '/login', return_url: return_url
      end

      def find(user_id)
        url    = url_for "/api/users/#{user_id}"
        raise ResourceNotFound.new(User, url) if !user_id || user_id == ''
        result = web_client.get url
        request_succeeded! result.status, url
        raw_user_attributes = JSON.parse result.body
        user_attributes     = convert_types raw_user_attributes
        User.new user_attributes
      end

      def update(attributes)
        attributes = attributes.dup
        user_id    = attributes.delete :id
        url        = url_for "/api/users/#{user_id}"
        result     = web_client.patch url, user: attributes
        result.status == OK_STATUS # probably inadequate in the long-run
      end

      def all(user_ids)
        slices = user_ids.count / 200
        slices = 1 if slices < 1

        _request_user_data(user_ids, slices)
      end

      def _request_user_data(user_ids, slices)
        raw_users_by_id = {}

        user_ids.each_slice(slices) do |user_ids|
          url    = url_for("/api/users", ids: user_ids)
          result = web_client.get(url)

          request_succeeded!(result.status, url)
          raw_users_by_id = raw_users_by_id.merge(JSON.parse(result.body))
        end

        Hash[
          raw_users_by_id.map { |id, raw_user| [id.to_i, User.new(convert_types raw_user)] }
        ]
      end

      def inspect
        "#<#{self.class} to #{base_url.inspect}>"
      end

      private

      attr_accessor :web_client, :base_url

      def url_for(path, query_params={})
        base_url + path + to_query_string(query_params)
      end

      def request_succeeded!(status, url)
        return if status == OK_STATUS
        case status
        when NOT_FOUND_STATUS    then raise ResourceNotFound.new(User, url)
        when UNAUTHORIZED_STATUS then raise ClientIsUnauthorized
        else                          raise "Unexpected status: #{status}"
        end
      end

      # there's only one test on this, IDK why it's not just a method in CGI
      # implementation is half-stolen from Rails, and half just "well this makes sense" :/
      def to_query_string(params)
        return '' if params.empty?       # => false, false
        '?' << _to_query_string(params)  # => "?ids%5B%5D=1&ids%5B%5D=4&ids%5B%5D=6", "?id=1"
      end

      def _to_query_string(params)
        params.map { |key, value|
          case value
          when Array
            value.map { |_value| "#{CGI.escape key.to_s + '[]'}=#{CGI.escape _value.to_s}" }
          else
            "#{CGI.escape key.to_s}=#{CGI.escape value.to_s}"
          end
        }.join('&')
      end

      def convert_types(raw_user_attributes)
        raw_user_attributes.merge \
          'created_at' => DateTime.strptime(raw_user_attributes.fetch('created_at'), TIME_FORMAT),
          'updated_at' => DateTime.strptime(raw_user_attributes.fetch('updated_at'), TIME_FORMAT)
      end
    end
  end
end
