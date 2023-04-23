require_relative 'table'
require_relative 'dealer'
require_relative 'player'
require_relative 'card'
require_relative 'game_mode'

class ShowText 
    attr_accessor :table

    def initialize
        @table = nil
    end
    
    def opening_remarks
        puts "ブラックジャックを開始します。"
    end
    
    def ask_bet
        puts '10枚のチップを所持しています。'
        loop do
            puts 'BETするチップの枚数を入力してください（1〜10）'
            bet = gets.chomp.to_i
            return bet if 1 <= bet && bet <= 10
        end
    end

    def tell_dealed_card
        record = @table.recent_whose_change
        name = record[:who].name
        suit = GameMode::SUIT[record[:change].suit]
        display = record[:change].display
        puts "#{name}の引いたカードは#{suit}の#{display}です"
    end
    
    def tell_second_dealer_card
        card = @table.second_dealer_card
        puts "ディーラーの引いた2枚目のカードは#{GameMode::SUIT[card.suit]}の#{card.display}でした。"
    end
    
    def tell_current_score(member)
        score = @table.hand_score(member)
        puts "#{member.name}の現在の得点は#{score}です。"
    end

    def ask_player_hit(player)
        tell_current_score(player)
        loop do
            puts "カードを引きますか？（Y/N）"
            input = gets.chomp.upcase.to_sym
            return input if input == :Y || input == :N
        end
    end

    def tell_after_action #TODO 他アクション時のテキスト
        action = @table.recent_whose_change[:what]
        case action
        when :hit
            tell_dealed_card
        end
    end

    def tell_second_dealer_card_hidden
        puts 'ディーラーの引いた2枚目のカードはわかりません。'
    end
    
    def tell_bust
        puts 'バースト！'
    end
    
    def tell_score_result(members)
        puts '--結果--'
        members.each do |member|
            name = member.name
            score = @table.hand_score(member)
            if score == :bust
                puts "#{name}はバーストしました。"
            else
                puts "#{name}の得点は#{score}です。"
            end
        end
    end
    
    def tell_winner(winner)
        case winner
        when Dealer
            puts 'ディーラーの勝ちです。'
        when :even
            puts '引き分けです。'
        when Player
            puts "#{winner.name}の勝ちです！"
        end
    end
    
    def tell_fin
        puts 'ブラックジャックを終了します。'
    end

    def tell_bet_result(winner)
        case winner
        when Dealer
            puts 'ベットしたチップは回収されます。'
        when :even
            puts 'ベットしたチップは戻ります。'
        when Player
            payout = @table.player_bet * GameMode::PAYOUT_RATE
            puts "配当は#{payout}枚です。"
        end
    end

    #GameManager
    def ask_stage
        #TODO 別ステージ作成後、選択制にする
        :simple
    end
    
    #GameManager
    def tell_game_result(init_chips, result_chips)
        diff = result_chips - init_chips
        if diff > 0
            puts "チップは#{diff}枚増加し、#{result_chips}枚になりました。"
        elsif diff == 0
            puts "チップは開始時から変わらず#{result_chips}枚でした。"
        else
            diff = diff.abs
            puts "チップは#{diff}枚減少し、#{result_chips}枚になりました。"
        end
    end
end