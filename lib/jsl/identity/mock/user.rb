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
        define_accessor(:login)              { 'twilight_time' }
        define_accessor(:referred_by)        { 'Alan Turing' }
        define_accessor(:github_id)          { 34 }
        define_accessor(:avatar_url)         { 'http://1.bp.blogspot.com/_bfLHIHMqOWM/TIutlY12yYI/AAAAAAAABrk/9iF3y8Q_q9g/s1600/russianlullabies.jpg' }
        define_accessor(:gravatar_id)        { 56 }
        define_accessor(:is_admin)           { false }
        define_accessor(:created_at)         { @created_at ||= 10.days.ago }
        define_accessor(:updated_at)         { created_at }
        define_accessor(:is_invited)         { true }
        define_accessor(:referred_by)        { 'Mah friend!' }
        define_accessor(:applicant_url)      { 'https://asquared.turing.io/admin/applicants/1' }
        define_accessor(:phone_number)       {  '303-731-3117' }

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
