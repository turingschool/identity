require_relative '../test_helper'
require_relative 'helper'

module Jsl
  module Identity
    class UserTest < MiniTest::Unit::TestCase
      include Jsl::Identity::TestHelpers

      def test_implements_the_user_interface
        assert_same_interface Mock::User, User
      end

      def test_it_knows_its_attributes
        user = User.new id:          12,
                        name:        'the name',
                        email:       'the email',
                        location:    'the location',
                        username:    'the username',
                        github_id:   'the github id',
                        avaatar_url: 'the avatar url',
                        gravatar_id: 'the avatar id',
                        created_at:  1.day.ago.to_date,
                        updated_at:  1.day.ago.to_date

        assert_equal 12,                user.id
        assert_equal 'the name',        user.name
        assert_equal 'the email',       user.email
        assert_equal 'the location',    user.location
        assert_equal 'the username',    user.username
        assert_equal 'the github id',   user.github_id
        assert_equal 'the avatar url',  user.avaatar_url
        assert_equal 'the avatar id',   user.gravatar_id
        assert_equal 1.day.ago.to_date, user.created_at
        assert_equal 1.day.ago.to_date, user.updated_at

        assert_equal true,  User.new(is_admin:  true).is_admin
        assert_equal true,  User.new(is_admin:  true).admin?
        assert_equal false, User.new(is_admin: false).is_admin
        assert_equal false, User.new(is_admin: false).admin?

        assert_equal true,  User.new(is_admin:  true).is_admin
        assert_equal true,  User.new(is_admin:  true).admin?
        assert_equal false, User.new(is_admin: false).is_admin
        assert_equal false, User.new(is_admin: false).admin?
      end
    end
  end
end
