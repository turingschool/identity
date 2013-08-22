module Eloquiz
  class MassageTherapist < Question
    attr_reader :therapist, :a, :b, :c, :d, :e, :f, :g
    def initialize(players)
      @therapist, @a, @b, @c, @d, @e, @f, @g = *players
    end

    def prompt
      "Massage therapist #{therapist} has seven loyal customers that schedule an appointment each Friday.#{a}, #{b}, #{c}, #{d}, #{e}, #{f} and #{g}. The schedule varies from week to week, according to the following constraints:"
    end

    def rules
      [
        "#{b} always has the 2nd or 6th appointment.",
        "If #{e} has an earlier appointment than #{c}, then #{a} is scheduled later than #{g}.",
        "If #{e} has a later appointment than #{c}, then #{a} is scheduled earlier than #{g}.",
        "Exactly two customers must be scheduled between the appointments for #{c} and #{b}.",
        "#{a} must be scheduled immediately before or immediately after #{b} since they are business partners and travel together.",
        "#{c} is scheduled earlier than #{f} or #{g}, but not both."
      ]
    end

    def answers
      [
        appointments(f, d, c, e, a, b, g)
      ]
    end

    def red_herrings
      [
        appointments(e, d, c, g, a, b, f),
        appointments(a, b, g, c, e, f, d),
        appointments(d, b, f, a, c, e, g),
        appointments(g, b, a, d, c, f, e)
      ]
    end

    def type
      :possible
    end

    private

    def appointments(*clients)
      clients.zip((1..7).to_a).map do |client, slot|
        "#{client}: ##{slot}"
      end.join(', ')
    end

  end
end

