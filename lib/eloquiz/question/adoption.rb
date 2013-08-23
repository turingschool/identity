module Eloquiz
  class Adoption < Question
    def self.generate
      new characters(9)
    end

    def self.ages
      (1..18).to_a.sample(7).sort
    end

    attr_reader :parent1, :parent2,
      :a, :b, :c, :d, :e, :f, :g,
      :y1, :y2, :y3, :y4, :y5, :y6, :y7
    def initialize(players, ages = Adoption.ages)
      @a, @b, @c, @d, @e, @f, @g, @parent1, @parent2 = *players
      @y1, @y2, @y3, @y4, @y5, @y6, @y7 = *ages
    end

    def setup
      "#{parent1} and #{parent2} have adopted 7 children: #{a}, #{b}, #{c}, #{d}, #{e}, #{f} and #{g}. The children are #{y1}, #{y2}, #{y3}, #{y4}, #{y5}, #{y6}, and #{y7} years old."
    end

    def rules
      [
        "None of the other children come between #{a} and #{c} in age.",
        "#{c} is older than #{e}",
        "If #{e} is not #{y4} years old then #{d} is #{y4} years old.",
        "At least one child is between the ages of #{f} and #{g}."
      ]
    end

    def answers
      [
        ages(e, a, c, d, f, b, g),
      ]
    end

    def red_herrings
      [
        ages(a, c, d, e, f, b, g),
        ages(b, f, a, e, c, g, d),
        ages(e, c, a, d, g, f, b),
        ages(e, f, c, a, d, g, b)
      ]
    end

    def type
      :possible
    end

    private

    def ages(*kids)
      [y1, y2, y3, y4, y5, y6, y7].zip(kids).map do |age, kid|
        "#{kid} is #{age}"
      end.join(", ")
    end

  end
end

