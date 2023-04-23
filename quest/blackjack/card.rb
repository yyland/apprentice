class Card
    attr_reader :suit, :num, :display, :point

    def initialize(suit, num, display: , point: )
        @suit = suit
        @num = num
        @display = display
        @point = point
    end

    def point(switch: :large)
        @point.is_a?(Integer) ? @point : @point[switch]
    end
end