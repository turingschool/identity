class Application < ActiveRecord::Base
  include OwnerSlug
  include Steps

  belongs_to :user, inverse_of: :application
  alias_method :owner, :user

  serialize :completed_steps, Array
  # It is NOT validating the file type. What the heck?
  mount_uploader :resume, ResumeUploader
end

