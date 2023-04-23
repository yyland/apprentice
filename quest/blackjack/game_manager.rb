require_relative 'show_text'
require_relative 'simple_stage.rb'

class GameManager

    PLAYER_DEFAULT_NAME = 'あなた'
    INICIAL_CHIPS = 10

    def initialize
        @game_phase = :setting
        @stage = :simple
        @player = nil
        @show_text = nil
    end
    
    def update
        case @game_phase
        when :setting
            @player = Player.new(PLAYER_DEFAULT_NAME, INICIAL_CHIPS)
            @show_text = ShowText.new
            @game_phase = :select_stage

        when :select_stage
            stage_choice = @show_text.ask_stage
            case stage_choice #TODO simple以外のステージ追加
            when :simple
                @stage = SimpleStage.new(@show_text, @player)
            end
            @game_phase = :playing

        when :playing 
            @stage.update
            @game_phase = :result if @stage.fin?

        when :result 
            @show_text.tell_game_result(INICIAL_CHIPS, @player.chips)
            @game_phase = :fin

        when :fin
            #終了待機
        end
    end

    def fin?
        @game_phase == :fin
    end
end