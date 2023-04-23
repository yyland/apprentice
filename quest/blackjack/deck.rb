require_relative 'card'

class Deck

    def initialize
        @cards = []
    end

    def add_card(card, card_set_num)
        card_set_num.times do
            @cards << card
        end
    end

    def shuffle_cards
        @cards.shuffle!
    end

    def release_card
        @cards.shift
    end
end