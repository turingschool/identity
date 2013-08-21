module Eloquiz
  class Hackday < Question
    PROJECTS = ["Botnet", "Gene Sequencing", "Video Game", "3D Mapping", "Facial Recognition", "Poetry Generation"]

    def self.projects
      PROJECTS.sample(3)
    end

    attr_reader :project1, :project2, :project3,
      :a, :b, :c, :d, :e, :f, :g, :h

    def initialize(players, projects = Hackday.projects)
      @a, @b, @c, @d, @e, @f, @g, @h = *players
      @project1, @project2, @project3 = *projects
    end

    def prompt
      "Eight people participate in a local programming challenge: #{a}, #{b}, #{c}, #{d}, #{e}, #{f}, and #{g}. There are 3 possible projects that they may choose to work on: #{project1}, #{project2}, and #{project3}."
    end

    def rules
      [
        "Nobody may work alone.",
        "The maximum team size is 3 people.",
        "#{c} is on the #{project1} project.",
        "Neither #{e} nor #{h} are on the #{project2} project.",
        "#{d} is not teamed up with #{e} or #{g}.",
        "If #{b} is on the #{project1} project, then #{g} and #{h} are on the #{project3} team.",
        "#{b} and #{e} are both on the #{project1} team."
      ]
    end

    def answers
      [
        "#{f} is on the #{project3} team.",
      ]
    end

    def red_herrings
      [
        "#{a} is on the #{project1} team.",
        "#{c} is on the #{project2} team.",
        "#{d} is on the #{project3} team.",
        "#{g} is on the #{project2} team."
      ]
    end

    def type
      :possible
    end
  end
end

