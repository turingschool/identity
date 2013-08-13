class Application < ActiveRecord::Base
  belongs_to :user
  serialize :completed_steps, Array
end
