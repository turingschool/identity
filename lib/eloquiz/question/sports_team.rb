module Eloquiz
  class SportsTeam < Question
    def self.generate
      new characters(4)
    end

    SPORTS = %w(soccer wiffleball baseball basketball teeball curling volleyball)
    attr_reader :a, :b, :c, :d, :sport
    def initialize(players, sport = SportsTeam::SPORTS.sample)
      @a, @b, @c, @d = *players
      @sport = sport
    end

    def setup
      "A #{sport} team recently recruited 4 new members: #{a}, #{b}, #{c}, and #{d}. Each member got to choose the number on their uniform. There were 7 available numbers: 3, 8, 13, 22, 31, 52, 89"
    end

    def rules
      [
        "#{c} chose a higher number than #{b} and a lower number than #{d}.",
        "#{b} chose an even number.",
        "#{a} chose one of the two highest numbers."
      ]
    end

    def answers
      [
        "Nobody chose a number between #{b} and #{a}."
      ]
    end

    def red_herrings
      [
        "Nobody chose number 3.",
        "#{d} chose number 89.",
        "#{a} chose number 89.",
        "#{b} chose number 22.",
        "#{c} chose number 22.",
        "#{c} chose an odd number.",
        "#{d} chose an even number.",
        "#{d} chose an odd number.",
        "Nobody chose a number between #{b} and #{d}.",
      ]
    end

    def type
      :false
    end
  end
end

