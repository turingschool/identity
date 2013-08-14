
User.destroy_all
Application.destroy_all
FileUtils.rm_rf('./public/uploads')

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

def handle(step, application)
  case step
  when :resume
    application.resume = File.open './test/fixtures/hello.pdf'
  when :video
    application.video_url = 'http://www.youtube.com/watch?v=7SSc1mQ4-Ck'
  when :essay
    application.essay_url = 'https://gist.github.com/kytrinyx/bd16f22641e48535a412'
  else
    # do nothing
  end
end

users = []
(1..500).each do |i|
  user = User.create(Person.new(i).to_h)
  user.apply!
  app = user.application
  Flow.random_progression.each do |step|
    handle(step, app)
    app.complete step
    app.save
  end
end
