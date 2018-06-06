Card = Class{
    init = function(self, loader)
        local suits = {[1] = 'spades', [2] = 'clubs', [3] = 'hearts', [4] = 'diamonds'}
        local ranks = {
            [1] = 'ace',
            [2] = '2',
            [3] = '3',
            [4] = '4',
            [5] = '5',
            [6] = '6',
            [7] = '7',
            [8] = '8',
            [9] = '9',
            [10] = '10',
            [11] = 'jack',
            [12] = 'queen',
            [13] = 'king'
        }
        self.rank = math.random(1,#ranks)
        self.suit = math.random(1,#suits)
        local rank = ranks[self.rank]
        local suit = suits[self.suit]
        self.filename = string.format('assets/%s_of_%s.png', rank, suit)
        loader:insertCard(self)
    end;

    draw = function(self, x, y, loader, down)
        if down then
            love.graphics.draw(loader.cards['back'], x, y)
        else
            love.graphics.draw(loader.cards[self.filename], x, y)
        end
    end
}

