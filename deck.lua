Deck = Class
{
    init = function(self)
        self:shuffle()
    end;

    getCard = function(self, loader)
        local card = Card(loader)

        while self.used[card.filename] do
            card = Card(loader)
        end
        self.used[card.filename] = true
        self.dealt = self.dealt+1
        return card
    end;    

    deal = function(self, player, loader)
        table.insert(player.hand, self:getCard(loader))
        self:update()
    end;

    shuffle = function(self)
        self.used = {}
        self.dealt = 0
    end;

    update = function(self)
        if self.dealt > 35 then
            self:shuffle()
        end
    end;

    draw = function(self)
        love.graphics.print(self.dealt, 10,10)
    end;
}