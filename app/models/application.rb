class Application < ActiveRecord::Base
  include OwnerSlug
  include Steps

  belongs_to :user, inverse_of: :application
  alias_method :owner, :user

  serialize :completed_steps, Array
  mount_uploader :resume, ResumeUploader
end

