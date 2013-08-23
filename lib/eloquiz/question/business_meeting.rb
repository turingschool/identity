module Eloquiz
  class BusinessMeeting < Question
    def self.generate
      new characters(4)
    end

    attr_reader :x, :y, :z, :protagonist
    def initialize(players)
      @x, @y, @z, @protagonist = *players
    end

    def setup
      "#{protagonist} is the CEO of a successful software consulting company, and has a full day of meetings scheduled. Two of the meetings are in the morning, then there is a lunch meeting, and two of the meetings are scheduled for the afternoon."
    end

    def rules
      [
        "#{x} is scheduled earlier in the day than #{y}.",
        "#{z} is scheduled immediately after lunch.",
        "There is exactly one meeting scheduled between the meeting with #{x} and the meeting with #{y}."
      ]
    end

    def answers
      [
        "#{x} has a meeting first thing in the morning.",
        "#{x} is having lunch with #{protagonist}.",
        "#{y} is having lunch with #{protagonist}.",
        "#{y} is the last meeting of the day.",
      ]
    end

    def red_herrings
      [
        "#{y} is in the morning.",
        "#{x} is right before lunch.",
        "#{x} has a morning meeting and #{y} is meeting with #{protagonist} in the afternoon.",
        "Neither #{x} nor #{y} have the lunch meeting."
      ]
    end

    def type
      :possible
    end
  end
end

