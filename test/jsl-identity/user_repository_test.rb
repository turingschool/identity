require_relative '../test_helper'
require_relative 'helper'

module Jsl
  module Identity
    class UserRepositoryTest < Minitest::Test
      include Jsl::Identity::TestHelpers
      include Test::Helpers::Controller

      def test_implements_the_user_interface
        assert_same_interface Mock::UserRepository, UserRepository
      end

      def test_find_can_find_a_user
        app_user = ::User.create!  name:        "Sherwin",
                                   email:       "sherwin@example.com",
                                   location:    "here",
                                   username:    "super_duper_sherwin",
                                   github_id:   12121212,
                                   avatar_url:  "some avatar url",
                                   gravatar_id: "some gravatar id",
                                   is_admin:    true

        client_user = user_repository.find app_user.id

        assert_equal app_user.id,              client_user.id
        assert_equal app_user.name,            client_user.name
        assert_equal app_user.email,           client_user.email
        assert_equal app_user.location,        client_user.location
        assert_equal app_user.username,        client_user.username
        assert_equal app_user.github_id,       client_user.github_id
        assert_equal app_user.avatar_url,      client_user.avatar_url
        assert_equal app_user.gravatar_id,     client_user.gravatar_id
        assert_equal app_user.is_admin,        client_user.is_admin
        assert_equal app_user.created_at.to_i, client_user.created_at.to_i # if you don't to_i it, it takes fractional seconds into consideration or something
        assert_equal app_user.updated_at.to_i, client_user.updated_at.to_i # and can't do in delta, because the units don't match up right and fkn everything passes -.^
        refute client_user.invited?
      end

      def test_find_raises_resource_not_found_when_cant_find_user
        assert_raises Jsl::Identity::ResourceNotFound do
          user_repository.find 99999999999
        end
      end

      def test_raises_unauthorized_error_when_unauthorized
        assert_raises Jsl::Identity::ClientIsUnauthorized do
          web_client = user_repository.send :web_client
          session    = web_client.send :session
          session.basic_authorize 'fake name', 'fake secret'
          user_repository.find 1
        end
      end

      def test_knows_the_login_url
        # yeah, I know it would be better to do login_url
        # but doesn't look like I can get that without either a ton of hacky work
        # or mutating the singleton routes object, so fuck it
        assert_equal url_helpers.login_path(return_url: 'http://example.com'),
                     user_repository.login_url('http://example.com')
      end

      def test_puts_user_data_back_to_server
        user = ::User.create!name: "Sherwin", email: "sherwin@example.com"
        refute_equal 'NEW ID', user.stripe_customer_id
        assert user_repository.update(id: user.id, stripe_customer_id: 'NEW ID')
        assert_equal 'NEW ID', user.reload.stripe_customer_id
      end
    end
  end
end
