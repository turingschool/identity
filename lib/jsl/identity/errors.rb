module Jsl
  module Identity
    # so all our errors have a common superclass
    JslError = Class.new ::StandardError

    class ResourceNotFound < JslError
      def initialize(klass, url)
        super "Could not find a #{klass.name} at #{url.inspect}"
      end
    end

    class ClientIsUnauthorized < JslError
      def initialize
        super "Identity client is not authorized to talk to back-end repository (asquared). "\
              "Make sure your username and password are correct, and exist in the remote_clients table in asquared. "\
              "The credentials probably come from config/secrets.yml"
      end
    end
  end
end
