require 'faker'
require 'active_support/core_ext/string/inflections'
require './lib/eloquiz/option'
require './lib/eloquiz/answer_key'
require './lib/eloquiz/question'
require './lib/eloquiz/question/conference_swag'
require './lib/eloquiz/question/adoption'
require './lib/eloquiz/question/book_club'
require './lib/eloquiz/question/hackday'
require './lib/eloquiz/question/spilled_milk'
require './lib/eloquiz/question/business_meeting'
require './lib/eloquiz/question/negotiations'
require './lib/eloquiz/question/extracurricular_activities'
require './lib/eloquiz/question/sports_team'
require './lib/eloquiz/question/massage_therapist'
require './lib/eloquiz/question/family_reunion'
require './lib/eloquiz/question/game_night'

module Eloquiz
  def self.progression
    [
      :conference_swag, :adoption, :hackday,
      :spilled_milk, :book_club, :business_meeting,
      :negotiations, :extracurricular_activities,
      :sports_team, :massage_therapist, :family_reunion,
      :game_night
    ]
  end

  def self.questions
    progression.map {|slug|
      generate_from(slug)
    }
  end

  def self.generate_from(slug)
    "Eloquiz::#{slug.to_s.camelize}".constantize.send(:generate)
  end
end

