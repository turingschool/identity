module Eloquiz
  class FamilyReunion < Question
    def self.generate
      new characters(12)
    end

    def self.family_names
      names = Set.new
      until names.size == 3
        names.add Faker::Name.last_name
      end
      names
    end

    attr_reader :family_a, :family_b, :family_c,
      :a1, :a2, :a3, :b1, :b2, :b3, :c1, :c2, :c3
    def initialize(players, family_names = FamilyReunion.family_names)
      @a1, @a2, @a3, @b1, @b2, @b3, @c1, @c2, @c3 = *players
      @family_a, @family_b2, @family_b = *family_names
    end

    def setup
      "The clan's annual reunion is a pretty big deal. Or a pretty big ordeal depending on who you ask. The worst part is the speeches, but there's no getting around them. The #{family_a} family (#{a1}, #{a2}, and #{a3}), the #{family_b} family (#{b1}, #{b2}, and #{b3}), and the #{family_c} family (#{c1}, #{c2}, and #{c3}) are trying to figure out who is going to speak, and in which order."
    end

    def rules
      [
        "Exactly two members of each family must give a speech.",
        "#{a2} and #{a3} can't both speak.",
        "#{b1} and #{a2} can't both speak.",
        "If #{b2} speaks, then #{b3} must also speak.",
        "If #{c2} and #{b1} both speak, then #{c2} must speak earlier than #{b1}",
        "If #{c1} and #{a3} both speak, then #{c1} must speak immediately before #{a3}.",
        "Either #{b1} or #{b3} speaks first.",
        "Either #{c2} or #{c3} speaks fifth."
      ]
    end

    def answers
      [
        speakers(b3, c2, b1, a1, c3, a3)
      ]
    end

    def red_herrings
      [
        speakers(b3, b2, a2, c2, c3, a3),
        speakers(b1, a1, b2, a3, c2, c3),
        speakers(b1, b3, a3, c1, c3, a1),
        speakers(b2, b3, c3, a1, c2, a3)
      ]
    end

    def type
      :possible
    end

    private

    def speakers(*names)
      names.zip((1..6).to_a).map do |speaker, slot|
        "#{slot}: #{speaker}"
      end.join(', ')
    end

  end
end

