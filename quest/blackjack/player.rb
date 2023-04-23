require_relative 'table'
require_relative 'dealer'

class Player
    attr_accessor :name, :chips, :table, :dealer

    def initialize(name, chips)
        @name = name
        @chips = chips
        @table = nil
        @dealer = nil
    end

    def bet(chips, hand: 0)
        @table.set_betting_chips_to(self, chips)
        @chips -= chips
    end

    def hit
        @dealer.deal_card_to(self)
    end
end