class Application < ActiveRecord::Base
  include OwnerSlug

  belongs_to :user, inverse_of: :application
  alias_method :owner, :user

  serialize :completed_steps, Array
end

