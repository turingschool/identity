require 'surrogate'

module Jsl
  module Identity
    module Mock
      class User
        Surrogate.endow self
        define_accessor(:id)                 { 12 }
        define_accessor(:name)               { 'Havalina' }
        define_accessor(:email)              { 'havalina@example.com' }
        define_accessor(:location)           { 'Kaliningrad' }
        define_accessor(:username)           { 'twilight_time' }
        define_accessor(:github_id)          { 34 }
        define_accessor(:avatar_url)         { 'http://1.bp.blogspot.com/_bfLHIHMqOWM/TIutlY12yYI/AAAAAAAABrk/9iF3y8Q_q9g/s1600/russianlullabies.jpg' }
        define_accessor(:gravatar_id)        { 56 }
        define_accessor(:is_admin)           { false }
        define_accessor(:created_at)         { @created_at ||= 10.days.ago }
        define_accessor(:updated_at)         { created_at }
        define_accessor(:is_invited)         { true }
        define_accessor(:stripe_customer_id) { nil }

        define(:admin?)                      { is_admin }
        define(:invited?)                    { is_invited }

        def is_invited!
          @invited_p = true
          self
        end

        def is_not_invited!
          @invited_p = false
          self
        end
      end
    end
  end
end

