
User.destroy_all
Application.destroy_all

require 'faker'
class Person

  attr_reader :github_id
  def initialize(i)
    @github_id = -1 * i
  end

  def name
    @name ||= Faker::Name.first_name + ' ' + Faker::Name.last_name
  end

  def email
    @email ||= Faker::Internet.email(name)
  end

  def username
    @username ||= Faker::Internet.user_name(name)
  end

  def location
    @location ||= random_location
  end

  def to_h
    {
      github_id: github_id,
      username: username,
      name: name,
      email: email,
      location: location
    }
  end

  private

  def random_location
    if rand(10) == 0
      Faker::Address.city + ', ' + Faker::Address.country
    else
      Faker::Address.city + ', ' + Faker::Address.state
    end
  end
end

class Flow
  extend Steps

  def self.random_progression
    progression[0..rand(progression.size)]
  end
end

users = []
(1..500).each do |i|
  user = User.create(Person.new(i).to_h)
  user.apply!
  app = user.application
  Flow.random_progression.each do |step|
    app.complete! step
  end
end
