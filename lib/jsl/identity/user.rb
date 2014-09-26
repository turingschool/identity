module Jsl
  module Identity
    class User
      attr_accessor :id,
                    :name,
                    :email,
                    :location,
                    :username,
                    :referred_by,
                    :github_id,
                    :avatar_url,
                    :gravatar_id,
                    :stripe_customer_id,
                    :is_admin,
                    :is_invited,
                    :created_at,
                    :updated_at,
                    :applicant_url

      def initialize(attributes)
        attributes.each { |name, value| instance_variable_set "@#{name}", value }
      end

      alias admin?   is_admin
      alias invited? is_invited
    end
  end
end
