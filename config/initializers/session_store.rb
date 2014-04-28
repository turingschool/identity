# Be sure to restart your server when you modify this file.

Asquared::Application.config.session_store :cookie_store,
  key:    '_turing_session',
  domain: :all

# to migrate sessions to use JSON (rails 4.1) instead of Marshall (rails 4.0)
Rails.application.config.action_dispatch.cookies_serializer = :hybrid
