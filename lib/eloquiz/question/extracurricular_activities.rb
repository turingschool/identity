module Eloquiz
  class ExtracurricularActivities < Question
    def self.generate
      new characters(4)
    end

    ACTIVITIES = [
      "goes biking",
      "attends a painting workshop",
      "goes horsebackriding",
      "does gymnastics",
      "juggles",
      "goes rollerskating",
      "practices figureskating",
      "takes archery lessons",
      "takes fencing classes"
    ]

    attr_reader :a, :b, :c, :d,
      :activity1, :activity2, :activity3, :activity4

    def initialize(players, activities = ACTIVITIES.shuffle)
      @a, @b, @c, @d = *players
      @activity1, @activity2, @activity3, @activity4 = *activities
    end

    def setup
      "Four children #{a}, #{b}, #{c}, and #{d} attend various after school activities."
    end

    def rules
      [
        "#{a} and #{b} are best friends and attend exactly the same activities.",
        "#{c} #{activity1} on Tuesdays and Thursdays, and #{activity4} on Wednesdays.",
        "#{d} #{activity1} every Friday.",
        "#{b} never #{activity3}.",
        "#{a} #{activity4}.",
        "#{d} #{activity2}, as does #{a} and exactly one other child."
      ]
    end

    def answers
      [
        "#{c} #{activity2} and #{activity1}",
        "#{c} #{activity2} and #{activity4}"
      ]
    end

    def red_herrings
      [
        "#{a} #{activity1} and #{activity2}.",
        "#{b} #{activity1} and #{activity2}.",
        "#{b} #{activity2} and #{activity4}.",
        "#{c} #{activity1} and #{activity4} but not #{activity3}.",
        "#{d} #{activity4} but not #{activity3}."
      ]
    end

    def type
      :false
    end
  end
end
