Player = Class
{
    init = function(self)
        self.hand = {}
        self.cash = 500
        local screenH, cardH = 700, 145
        self.y = screenH - cardH - 10
        self.bet = 20
        self.lastbet = self.bet
        self.maxW = 1000
        self.firstTurn = true
        self.bust = false
    end;

    draw = function(self, loader)
        local x = (self.maxW - #self.hand * loader.cardW)/2

        for _,card in pairs(self.hand) do
            card:draw(x, self.y, loader)
            x = x + loader.cardW
        end
    end;

    emptyHand = function(self)
        self.hand = {}
    end
}