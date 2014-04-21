module Jsl
  module Identity
    # so all our errors have a common superclass
    Error = Class.new ::StandardError

    class ResourceNotFound < Error
      def initialize(klass, url)
        super "Could not find a #{klass.name} at #{url.inspect}"
      end
    end
  end
end
