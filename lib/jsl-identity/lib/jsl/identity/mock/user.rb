require 'surrogate'

module Jsl
  module Identity
    module Mock
      class User
        Surrogate.endow self
        define(:id)          { 12 }
        define(:name)        { 'Havalina' }
        define(:email)       { 'havalina@example.com' }
        define(:location)    { 'Kaliningrad' }
        define(:username)    { 'twilight_time' }
        define(:github_id)   { 34 }
        define(:avaatar_url) { 'http://1.bp.blogspot.com/_bfLHIHMqOWM/TIutlY12yYI/AAAAAAAABrk/9iF3y8Q_q9g/s1600/russianlullabies.jpg' }
        define(:gravatar_id) { 56 }
        define(:is_admin)    { false }
        define(:admin?)      { is_admin }
        define(:created_at)  { @created_at ||= 10.days.ago }
        define(:updated_at)  { created_at }
        define(:invited?)    { true }

        def is_invited
          @invited_p = true
          self
        end

        def is_not_invited
          @invited_p = false
          self
        end
      end
    end
  end
end

