require 'thor'

class Asquared
  class CLI < Thor
    desc "generate", "generate a quiz"
    def generate
      require 'eloquiz'

      Eloquiz.questions.each do |quiz|
        puts
        puts '-'*70

        puts quiz.setup
        puts
        quiz.rules.each do |rule|
          puts "* " + rule
        end
        puts
        puts quiz.prompt
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
