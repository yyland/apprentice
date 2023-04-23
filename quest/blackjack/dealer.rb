require_relative 'table'
require_relative 'card'

class Dealer
    attr_reader :name
    attr_accessor :table

    DEALER_DEFAULT_NAME = 'ディーラー'

    def initialize()
        @name = DEALER_DEFAULT_NAME
        @table = nil
    end

    def deal_card_to(member, hand: 0)
        card = @table.release_card_from_deck
        @table.set_card_to(member, card, hand: hand)
    end
end