# Turing Identity

Client to consume an api and return user identity data for JumpstartLab.
Currently used by [enroll](https://github.com/turingschool/enroll)
to consume identity data out of [apply](https://github.com/turingschool/apply).
Eventually, identity data will hopefully be extracted into its own application.

This app is tested by plugging it into `apply` and showing that it actually works.

This is to prevent divergence between the client and the API it is consuming.

## Releasing a version for services to consume

1. make your changes
1. commit them and make a pull request
1. merge to master
1. update the version number in `lib/jsl/identity/version.rb`
1. make a new commit with a message of `Bump version to <new version number>`
1. make a tag with `git tag v0.0.<new release num>`
1. run `git push && git push --tags`

Run `rake push`

Our gemfury username is turingschool, our email is jorge@turing.io. The password is on the `Turing Accounts and Passwords` document on Google Drive.

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
