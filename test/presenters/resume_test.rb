require './test/test_helper'

class ResumeTest < ActiveSupport::TestCase
  attr_reader :resume

  def setup
    user = User.create!
    user.apply!

    @resume = Resume.new(user)
  end

  test 'validates presence of file' do
    resume.upload('file.pdf')
    assert resume.valid?

    resume.upload(nil)
    refute resume.valid?
  end

  test 'it has a file' do
    resume.upload('file.pdf')
    assert_equal 'file.pdf', resume.file
  end
end