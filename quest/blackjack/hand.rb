require_relative 'card'
require_relative 'game_mode'

class Hand
    attr_reader :score

    def initialize
        @score = 0  # int or :bust
        @cards = []
    end

    def add_card(card)
        @cards << card
        update_score
    end

    def update_score
        ace_dif = GameMode::CARD[1][:point][:large] - GameMode::CARD[1][:point][:small]
        score = @cards.sum {|card| card.point}
        @cards.count{|card| card.num == 1}.times do
            break if score < GameMode::BUST_SCORE
            score -= ace_dif
        end
        @score = score >= GameMode::BUST_SCORE ? :bust : score
    end

    def second_card
        @cards[1]
    end
end