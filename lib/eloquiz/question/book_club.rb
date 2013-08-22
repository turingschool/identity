module Eloquiz
  class BookClub < Question

    attr_reader :a, :b, :c, :d, :e, :f, :g
    def initialize(players)
      @a, @b, @c, @d, @e, @f, @g = *players
    end

    def prompt
      "Seven children: #{a}, #{b}, #{c}, #{d}, #{e}, and #{f} started a bookclub together, and each child purchased one of the Harry Potter books."
    end

    def rules
      [
        "#{a} and #{c} bought consecutive books in the series.",
        "#{a} bought an earlier book than #{g}.",
        "#{c} bought a later book than #{e}.",
        "Either #{d} or #{e} bought book 4.",
        "#{f} and #{g} did not purchase consecutive books in the series.",
        "#{a} purchased book 3."
      ]
    end

    def answers
      [
        "#{b} purchased book 6."
      ]
    end

    def red_herrings
      [
        "#{c} purchased book 1.",
        "#{e} purchased book 4.",
        "#{f} purchased book 5.",
        "#{g} purchased book 7.",
      ]
    end

    def type
      :true
    end
  end
end

