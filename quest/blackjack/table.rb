require_relative 'card'
require_relative 'deck'
require_relative 'dealer'
require_relative 'player'

class Table
    attr_reader :player_bet, :recent_whose_change
    
    def initialize(deck, player_hands, dealer_hands)
        @deck = deck
        @player_hands = player_hands
        @dealer_hands = dealer_hands
        @player_bet = 0
        @recent_whose_change = {}
    end
    
    def hand_score(member, hand: 0)
        case member
        when Player then @player_hands[hand].score
        when Dealer then @dealer_hands[hand].score
        end
    end

    def set_betting_chips_to(player, chips, hand: 0)
        @player_bet += chips
        @recent_whose_change = {who: player, what: :bet, change: chips}
    end

    def release_card_from_deck
        @deck.release_card
    end

    def set_card_to(member, card, hand: 0)
        if member.class == Player
            @player_hands[hand].add_card(card)
            @recent_whose_change = {who: member, what: :hit, change: card}
        else
            @dealer_hands[hand].add_card(card)
            @recent_whose_change = {who: member, what: :hit, change: card}
        end
    end

    def second_dealer_card
        @dealer_hands[0].second_card
    end

end