Dealer = Class
{
    __includes = Player,

    init = function(self)
        Player.init(self)
        self.y = 10
        self.set = false
    end;

    draw = function(self, loader, hide)
        local x = (self.maxW - #self.hand * loader.cardW)/2

        if hide then
            for i,card in ipairs(self.hand) do
                if i == 1 then
                    card:draw(x, self.y, loader)
                else
                    card:draw(x, self.y, loader, true)
                end
                x = x + loader.cardW
            end
        else
            for _,card in pairs(self.hand) do
                card:draw(x, self.y, loader)
                x = x + loader.cardW
            end
        end
    end;

    logic = function(self, game)
        local total
        local ptotal = game:getTotal(game.player)
        
        if ptotal > 21 then
            self.set = true
        end

        while not self.set do
            total = game:getTotal(self)

            if total > ptotal or total >= 17 or total == ptotal then
                self.set = true
            else
                game.deck:deal(self, game.loader)
            end
        end
    end
}