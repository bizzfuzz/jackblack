Loader = Class
{
    init = function(self)
        self.cards = {}
        self.cards['back'] = love.graphics.newImage('assets/back.png')
        self.cardH = self.cards['back']:getHeight()
        self.cardW = self.cards['back']:getWidth()
        self.bg = love.graphics.newImage('assets/felt.png')
        self.scrW, self.scrH = 1000,700

        self.chips = {
            [10] = love.graphics.newImage('assets/10v.png'),
            [50] = love.graphics.newImage('assets/50v.png'),
            [100] = love.graphics.newImage('assets/100v.png')
        }
    end;

    insertCard = function(self, card)
        if not self.cards[card.filename] then
            self.cards[card.filename] = love.graphics.newImage(card.filename)
        end
    end;
}
