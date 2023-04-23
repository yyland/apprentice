require_relative 'game_manager'

game_manager = GameManager.new
while(true)
    game_manager.update
    break if game_manager.fin?
end