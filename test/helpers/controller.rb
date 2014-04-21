module Test
  module Helpers
    module Controller
      def path_to(fixture_file)
        File.join ActionController::TestCase.fixture_path, fixture_file
      end

      def set_current_user(user)
        raise "Cannot set current user outside the test environment" unless Rails.env.test?
        $current_user = user
      end

      def url_helpers
        @url_helpers ||= Rails.application.routes.url_helpers
      end

      def num_questions
        Eloquiz.random_questions.size
      end
    end
  end
end
