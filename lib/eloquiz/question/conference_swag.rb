module Eloquiz
  class ConferenceSwag < Question
    SWAG = %w(t-shirt hoodie beanie laptop-sleeve)
    COLORS = %w(pink white blue purple yellow turquoise green tan)

    def self.swag
      SWAG.sample(2)
    end

    def self.colors
      COLORS.sample(3)
    end

    attr_reader :swag1, :swag2, :x, :y, :z

    def initialize(swag = ConferenceSwag.swag, colors = ConferenceSwag.colors)
      @swag1, @swag2 = *swag
      @x, @y, @z = *colors
    end

    def prompt
      "Each attendee at a Ruby conference is given either a #{swag1} or a #{swag2}. The conference color theme is #{x}, #{y}, and #{z}, and each piece of swag is in one of these colors."
    end

    def rules
      [
        "If the swag is #{y}, then it is #{swag2}.",
        "A #{swag1} is never #{x}."
      ]
    end

    def answers
      [
        "A #{swag1} can only be #{z}."
      ]
    end

    def red_herrings
      [
        "A #{swag1} can be #{y} or #{z}.",
        "A #{swag2} can be #{x}, #{y} or #{z}.",
        "A #{swag1} must be #{y}.",
        "A #{swag2} must be either #{y} or #{z}."
      ]
    end

    def type
      :true
    end
  end
end

