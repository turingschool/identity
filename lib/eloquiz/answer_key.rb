module Eloquiz
  class AnswerKey
    def self.generate(options)
      options.find(&:answer?).fingerprint
    end

    def self.correct?(statement, choice, fingerprint)
      option = Option.new(statement, true, choice)
      option.fingerprint == fingerprint
    end
  end
end

