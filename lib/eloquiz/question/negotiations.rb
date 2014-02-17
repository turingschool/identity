module Eloquiz
  class Negotiations < Question
    def self.generate
      new characters(9)
    end

    def self.suffixes
      ["Inc", "Group", "and Sons", "LLC"]
    end

    def self.companies(n)
      names = Set.new
      until names.size == n
        names.add "#{Faker::Name.last_name} #{suffixes.sample}"
      end
      names
    end

    attr_reader :company_a, :company_b, :company_c,
      :a1, :a2, :a3, :b1, :b2, :b3, :c1, :c2, :c3
    def initialize(players, companies = Negotiations.companies(3))
      @company_a, @company_b, @company_c = *companies
      @a1, @a2, @a3, @b1, @b2, @b3, @c1, @c2, @c3 = *players
    end

    def setup
      "Three companies, #{company_a}, #{company_b}, and #{company_c} are negotiating a complicated deal. There are three possible representatives from each company. #{company_a} is represented by #{a1}, #{a2}, and #{a3}. #{company_b} is represented by #{b1}, #{b2}, and #{b3}. #{company_c} is represented by #{c1}, #{c2}, and #{c3}. Because there is a complicated history and bad blood between the representatives, the logistics for negotiation meetings are complicated."
    end

    def rules
      [
        "The same number of representatives must be present from each company.",
        "#{c1} and #{b2} cannot be in the same room together.",
        "#{b3} and #{c2} must always be present at the same meetings.",
        "If #{a1} is present, then so is #{b1}.",
        "When #{b2} is present, #{b3} is not allowed to be there."
      ]
    end

    def answers
      [
        representatives(a2, a3, b1, b3, c2, c3)
      ]
    end

    def red_herrings
      [
        representatives(a2, a3, b1, b2, c2, c3),
        representatives(a2, a3, c1),
        representatives(a1, b2, c2),
        representatives(a1, a2, b1, c1, c2, c3),
        representatives(a1, a2, b1, b2, c1, c3)
      ]
    end

    def type
      :possible
    end

    private

    def representatives(*names)
      "Attending: #{names.join(', ')}"
    end
  end
end

