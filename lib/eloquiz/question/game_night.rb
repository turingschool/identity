module Eloquiz
  class GameNight < Question

    attr_reader :a, :b, :c, :d
    def initialize(players)
      @a, @b, @c, @d = *players
    end

    def prompt
      "At the monthly game night, #{a}, #{b}, #{c}, and #{d} competed against each other in Scrabble and Chess."
    end

    def rules
      [
        "#{a} beat #{b} in chess, #{c} came third and the 16 year old won.",
        "#{a} came second in Scrabble, the 15 year old won, #{c} beat the 18 year old and the 19 year old came third.",
        "#{d} is 3 years younger than #{b}.",
          "The kid who came last in chess, came third in Scrabble and only one child got the same position in both games.",
      ]
    end

    def answers
      [
        "#{a} is 18 years old.",
        "#{b} is 19 years old.",
        "#{c} is 15 years old.",
        "#{d} is 16 years old.",
        "#{a} came in #2 in both Chess and Scrabble.",
        "#{b} came in #4 in Chess.",
        "#{b} came in #3 in Scrabble.",
        "#{c} came in #1 in Scrabble.",
        "#{d} came in #1 in Chess.",
        "#{d} came in #4 in Scrabble."
      ]
    end

    def red_herrings
      [
        "#{a} is 19 years old.",
        "#{a} is 15 years old.",
        "#{a} is 16 years old.",
        "#{b} is 15 years old.",
        "#{b} is 16 years old.",
        "#{b} is 18 years old.",
        "#{c} is 16 years old.",
        "#{c} is 18 years old.",
        "#{c} is 19 years old.",
        "#{d} is 15 years old.",
        "#{d} is 18 years old.",
        "#{d} is 19 years old.",
        "#{b} got the same position in both Chess and Scrabble.",
        "#{a} came in #4 in Chess.",
        "#{a} came in #3 in Scrabble.",
        "#{b} came in #3 in Chess.",
        "#{b} came in #2 in Scrabble.",
        "#{c} came in #4 in Scrabble.",
        "#{d} came in #2 in Chess.",
        "#{d} came in #3 in Scrabble."
      ]
    end

    def type
      :true
    end

  end
end

