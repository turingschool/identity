require 'surrogate'
require 'jsl/identity/errors'

module Jsl
  module Identity
    module Mock
      class UserRepository
        Surrogate.endow self
        define(:login_url) { |return_url| 'http://example.com' }

        define :find do |user_id|
          if will_find_nothing?
            raise ResourceNotFound.new User, "http://mock-request.fake/users/#{user_id}"
          else
            User.new.will_have_id user_id
          end
        end

        def will_find_nothing!
          @will_find_nothing = true
          self
        end

        def will_find_nothing?
          @will_find_nothing
        end
      end
    end
  end
end

