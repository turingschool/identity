require './test/test_helper'

class EssayTest < ActiveSupport::TestCase
	attr_reader :essay

	def setup
		user = User.create!
		user.apply!

		@essay = Essay.new(user)
	end

	test 'validates presence of url' do
		assert essay.update_attributes(url: 'URL')
		refute essay.update_attributes({})
	end

  test 'it has an url' do
    essay.update_attributes(url: 'URL')
    assert_equal 'URL', essay.url
  end
end