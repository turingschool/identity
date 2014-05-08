# JumpstartLab Identity

Client to consume an api and return user identity data for JumpstartLab.
Currently used by [register for class](https://github.com/JumpstartLab/register_for_class)
to consume identity data out of [asquared](https://github.com/JumpstartLab/asquared).
Eventually, identity data will hopefully be extracted into its own application.

This app is tested by plugging it into asquared and showing that it actually works.
This is to prevent divergence between the client and the api it is consuming.

## Releasing a version for services to consume

Run `rake push`

Our gemfury username is jumpstartlab, our email is contact@turing.io,
ask me for the password if you need it.

## Setup

```ruby
base_url        = 'http://localhost:3000'
name            = 'register_for_class'
secret          = 'some secret'
web_client      = Jsl::Identity::WebClients::NetHttp.new name, secret
user_repository = Jsl::Identity::UserRepository.new web_client: web_client, base_url:  base_url
user            = user_repository.find 1
user.id # => 1
```

## Test Setup

```ruby
username, secret = 'test_username', 'test_secret'
session = Rack::Test::Session.new(Rails.application)
session.basic_authorize username, secret
client = Jsl::Identity::WebClients::Rack.new session
user_repository = Jsl::Identity::UserRepository.new \
  web_client: client,
  base_url:   "" # no need for a base url in test env
user = user_repository.find 1
user.id # => 1
```
