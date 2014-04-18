module Jsl
  module Identity
    # so all our errors have a common superclass
    Error = Class.new ::StandardError

    class ResourceNotFound < Error
      def initialize(klass, identifier_type, identifier)
        super "Could not find a #{klass.name} with #{identifier_type} of #{identifier.inspect}"
      end
    end
  end
end
