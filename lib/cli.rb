require 'thor'

class Enrollist
  class CLI < Thor
    desc "generate", "generate a quiz"
    def generate
      require 'eloquiz'

      Eloquiz.questions.each do |quiz|
        puts
        puts '-'*70

        puts quiz.prompt
        puts
        quiz.rules.each do |rule|
          puts "* " + rule
        end
        puts
        puts quiz.question
        puts
        quiz.options.each do |option|
          puts "#{option.choice} - #{option.statement}"
        end
        puts
        puts "KEY: #{quiz.fingerprint}"
      end
    end
  end
end
