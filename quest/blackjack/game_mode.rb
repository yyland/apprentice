class GameMode

    CARD = {
        1 => {display: 'A', point: {large: 11, small: 1}},
        2 => {display: '2', point: 2},
        3 => {display: '3', point: 3},
        4 => {display: '4', point: 4},
        5 => {display: '5', point: 5},
        6 => {display: '6', point: 6},
        7 => {display: '7', point: 7},
        8 => {display: '8', point: 8},
        9 => {display: '9', point: 9},
        10 => {display: '10', point: 10},
        11 => {display: 'J', point: 10},
        12 => {display: 'Q', point: 10},
        13 => {display: 'K', point: 10},
    }

    SUIT = {
        heart: 'ハート',
        diamond: 'ダイヤ',
        spade: 'スペード',
        club: 'クラブ',
    }

    BET_UNIT = 10
    DEALER_MIN_SCORE = 17
    BUST_SCORE = 22
    CARD_SET_NUM_FOR_DECK = 4
    PAYOUT_RATE = 1

    def initialize
    end
end