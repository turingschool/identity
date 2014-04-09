require './test/test_helper'

class VideoTest < ActiveSupport::TestCase
	attr_reader :video

	def setup
		user = User.create!
		user.apply!

		@video = Video.new(user)
	end

	test 'validates presence of url' do
		assert video.update_attributes(url: 'URL')
		refute video.update_attributes({})
	end
end