module Jsl
  module Identity
    class Response
      attr_reader :status, :body
      def initialize(status, body)
        @status = status.to_i
        @body   = body.to_s
      end
    end
  end
end
