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

        define :find_by_name do |name|
          ids = [2, 3]
          Hash[
            ids.map { |id| [id, User.new.will_have_name(name).will_have_id(id)] }
          ]
        end

        define :all do |user_ids|
          Hash[
            user_ids.map { |id| [id, User.new.will_have_id(id)] }
          ]
        end

        define :update do |attributes|
          true
        end

        define :accept_invitation do |user_id|
          true
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

