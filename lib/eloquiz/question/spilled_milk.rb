module Eloquiz
  class SpilledMilk < Question

    attr_reader :a, :b, :c, :d, :e
    def initialize(players)
      @a, @b, @c, @d, @e = *players
    end

    def prompt
      "Five children, #{a}, #{b}, #{c}, #{d}, and #{e}, were having a snack after school, and one of them spilled the milk. When the grownups asked who was responsible, the children each told one lie and one truth."
    end

    def rules
      [
        "#{a} said: \"It was #{b}. It wasn't #{e}.\"",
        "#{b} said: \"It wasn't #{c}. It wasn't #{e}.\"",
        "#{c} said: \"It was #{e}. It wasn't #{a}.\"",
        "#{d} said: \"It was #{c}. It was #{b}.\"",
        "#{e} said: \"It was #{d}. It wasn't #{a}.\"",
      ]
    end

    def answers
      [
        "It was #{c}."
      ]
    end

    def red_herrings
      [
        "#{a} spilled the milk.",
        "#{b} spilled the milk.",
        "#{d} spilled the milk.",
        "#{e} spilled the milk."
      ]
    end

    def type
      :true
    end
  end
end

