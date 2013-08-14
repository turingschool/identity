class Evaluation < ActiveRecord::Base
  has_many :criteria
  belongs_to :user
  belongs_to :application
end
