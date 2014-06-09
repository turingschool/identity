$:.unshift '/Users/josh/code/jsl/jsl-identity'  # => ["/Users/josh/code/jsl/jsl-identity", "/Users/josh/.gem/ruby/2.1.1/gems/seeing_is_believing-2.1.2/lib", "/Applications/TextMate.app/Contents/SharedSupport/Support/lib", "/Users/josh/.rubies/ru...
require 'jsl/identity'                          # => true

base_url        = 'http://localhost:3000'                                                        # => "http://localhost:3000"
name            = 'register_for_class'                                                           # => "register_for_class"
secret          = 'some secret'                                                                  # => "some secret"
web_client      = Jsl::Identity::WebClients::NetHttp.new name, secret                            # => #<Jsl::Identity::WebClients::NetHttp:0x007ffa81abfc38 @username="register_for_class", @password="some secret">
user_repository = Jsl::Identity::UserRepository.new web_client: web_client, base_url:  base_url  # => #<Jsl::Identity::UserRepository:0x007ffa81abf9b8 @web_client=#<Jsl::Identity::WebClients::NetHttp:0x007ffa81abfc38 @username="register_for_class", @password="some secret">, @base_url="http://l...

# UserRepository#find
user = user_repository.find 501  # => #<Jsl::Identity::User:0x007ffa81ac8900 @id=501, @name="Josh Cheek", @email="josh.cheek@gmail.com", @location="Chicago, IL", @username="JoshCheek", @github_id=77495, @avatar_url="https://avatar...
user.name                        # => "Josh Cheek"
user.email                       # => "josh.cheek@gmail.com"

begin
  user_repository.find nil
rescue
  $!                        # => #<Jsl::Identity::ResourceNotFound: Could not find a Jsl::Identity::User at "http://localhost:3000/api/users/">
end                         # => #<Jsl::Identity::ResourceNotFound: Could not find a Jsl::Identity::User at "http://localhost:3000/api/users/">


# UserRepository#all
users = user_repository.all [1,2,501]  # => {1=>#<Jsl::Identity::User:0x007ffa81aa53b0 @id=1, @name="Kendall Bartoletti", @email="kendall_bartoletti@faybechtelar.org", @location="Zanderfurt, Hawaii", @username="kendall.bartoletti", @git...
user = users[501]                      # => #<Jsl::Identity::User:0x007ffa81aa4348 @id=501, @name="Josh Cheek", @email="josh.cheek@gmail.com", @location="Chicago, IL", @username="JoshCheek", @github_id=77495, @avatar_url="https://avatar...
user.name                              # => "Josh Cheek"
user.email                             # => "josh.cheek@gmail.com"
