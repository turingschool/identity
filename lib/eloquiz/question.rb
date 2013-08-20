module Eloquiz
  class Question
    class SubclassMustImplement < StandardError; end

    [:type, :rules, :prompt, :answers, :red_herrings].each do |message|
      define_method message do
        raise SubclassMustImplement.new("Must implement method `:#{message}`.")
      end
    end

    def options
      @options ||= itemize(random_options)
    end

    def itemize(alternatives)
      letters = %w(A B C D E)
      alternatives.each do |alternative|
        alternative.choice = letters.shift
      end
    end

    def random_options
      options = []
      red_herrings.shuffle.sample(4).each do |statement|
        options.push Eloquiz::Option.new(statement, false)
      end
      options.push Eloquiz::Option.new(answers.sample, true)
      options.shuffle
    end

    def fingerprint
      @fingerprint ||= options.find {|o| o.answer?}.fingerprint
    end

    def question
      case type
      when :possible
        "Which one of the following could be true?"
      when :true
        "Which one of the following must be true?"
      when :false
        "Which one of the following must be false?"
      end
    end
  end
end

