require 'faker'

module Factory
  class User
    def self.create_user(attributes={})
      user = ::User.new new(attributes).to_h
      yield user if block_given?
      user
    ensure
      user.save!
    end

    attr_reader :github_id
    def initialize(attributes={})
      attributes.each do |attribute, value|
        __send__ "#{attribute}=", value
      end
    end

    attr_accessor :is_admin, :github_id
    attr_writer :name, :email, :username, :location

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

    def complete_application(should_complete)
      return unless should_complete
    end

    def to_h
      { github_id: github_id,
        username:  username,
        name:      name,
        email:     email,
        location:  location,
        is_admin:  is_admin,
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

  module Apply
    extend Steps

    def self.random_progression
      progression[0..rand(progression.size)]
    end

    def self.complete(application)
      progression.each do |step|
        handle step, application
        application.complete step
      end
      application.save!
    end

    def self.randomly_progress(application)
      random_progression.each do |step|
        handle(step, application)
        application.complete step
      end
      application.save!
    end

    def self.handle(step, application)
      case step
      when :resume
        application.resume = File.open './test/fixtures/hello.pdf'
      when :video
        application.video_url = 'http://www.youtube.com/watch?v=7SSc1mQ4-Ck'
      when :essay
        application.essay_url = 'https://gist.github.com/kytrinyx/bd16f22641e48535a412'
      when :quiz
        QuizQuestions.generate_for(application, started_at: Time.now - rand(10000).minutes)
        application.quiz_questions.each do |question|
          option = random_answer_to(question)
          application.quiz_result(question.slug, {result: option.answer?, answer: option.statement})
        end
        application.quiz_completed_at = application.quiz_started_at + rand(30..90).minutes
      else
        # do nothing
      end
    end

    def self.random_answer_to(question)
      if rand(5) == 0
        question.options.reject(&:answer?).sample
      else
        question.options.find(&:answer?)
      end
    end
  end
end
