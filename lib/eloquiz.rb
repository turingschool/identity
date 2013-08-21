require 'faker'
require './lib/eloquiz/option'
require './lib/eloquiz/answer_key'
require './lib/eloquiz/question'
require './lib/eloquiz/question/business_meeting'
require './lib/eloquiz/question/extracurricular_activities'
require './lib/eloquiz/question/sports_team'

module Eloquiz
  def self.questions
    [
      BusinessMeeting.new(characters(4)),
      ExtracurricularActivities.new(characters(4)),
      SportsTeam.new(characters(4)),
    ]
  end

  def self.characters(n)
    names = Set.new
    until names.size == n
      names.add Faker::Name.first_name
    end
    names
  end
end
