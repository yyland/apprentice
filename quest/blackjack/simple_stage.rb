require_relative 'table'
require_relative 'card'
require_relative 'deck'
require_relative 'hand'
require_relative 'dealer'
require_relative 'player'
require_relative 'game_mode'
require_relative 'show_text'

class SimpleStage

    def initialize(show_text, player)
        @show_text = show_text
        @player = player
        @playing_step = :setting
        @dealer = nil
        @table = nil
    end

    def update
        case @playing_step
        when :setting
            @dealer = Dealer.new()
            deck = create_deck
            player_hand = [Hand.new, Hand.new]
            dealer_hand = [Hand.new, Hand.new]
            @table = Table.new(deck, player_hand, dealer_hand)
            @player.table = @table
            @player.dealer = @dealer
            @dealer.table = @table
            @show_text.table = @table
            @playing_step = :start

        when :start
            @show_text.opening_remarks
            betting_chips = @show_text.ask_bet
            @player.bet(betting_chips)
            first_dealling_cards
            @playing_step = :player

        when :player
            action = @show_text.ask_player_hit(@player)
            case action
            when :N then @playing_step = :dealer_start
            when :Y
                @player.hit
                @show_text.tell_after_action
                score = @table.hand_score(@player)
                if score == :bust
                    @show_text.tell_bust
                    @playing_step = :result
                end
            end

        when :dealer_start
            @show_text.tell_second_dealer_card
            @playing_step = dealer_continue? ? :dealer : :result

        when :dealer
            @show_text.tell_current_score(@dealer)
            @dealer.deal_card_to(@dealer)
            @show_text.tell_dealed_card
            @playing_step = :result unless dealer_continue?

        when :result
            @show_text.tell_score_result([@dealer,@player])
            winner = decide_winner
            @show_text.tell_winner(winner)
            process_bet_result(winner)
            @show_text.tell_bet_result(winner)
            @playing_step = :fin

        when :fin
            #終了待機
        end
    end

    def create_deck
        deck = Deck.new
        GameMode::SUIT.each_key do |suit|
            GameMode::CARD.each_pair do |num, element|
                card = Card.new(suit, num, **element)
                deck.add_card(card, GameMode::CARD_SET_NUM_FOR_DECK)
            end
        end
        deck.shuffle_cards
        deck
    end

    def first_dealling_cards
        2.times do 
            @dealer.deal_card_to(@player)
            @show_text.tell_dealed_card
        end
        @dealer.deal_card_to(@dealer)
        @show_text.tell_dealed_card
        @dealer.deal_card_to(@dealer)
        @show_text.tell_second_dealer_card_hidden
    end

    def dealer_continue?
        score = @table.hand_score(@dealer)
        score != :bust && score < GameMode::DEALER_MIN_SCORE
    end

    def decide_winner
        dealer_score = @table.hand_score(@dealer)
        player_score = @table.hand_score(@player)
        return @player if dealer_score == :bust
        return @dealer if player_score == :bust
        case player_score <=> dealer_score
        when -1 then @dealer
        when 0 then :even
        when 1 then @player
        end
    end

    def process_bet_result(winner)
        bet = @table.player_bet
        case winner
        when :even
            @player.chips += bet
        when Player
            payout = bet * GameMode::PAYOUT_RATE
            @player.chips += (bet + payout)
        end
    end

    def fin?
        @playing_step == :fin
    end
end