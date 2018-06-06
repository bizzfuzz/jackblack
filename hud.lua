HUD = Class
{
    init = function(self)
        self.screenW = 1000
        self.screenH = 700
        self.betx, self.bety = self.screenW/2-85, self.screenH/2-20
        self.boxes = {
            normal = {'fill', 5, 5, 100, 45},
            descision = {'fill', 5, 5, 100, 105},
            desSmall = {'fill', 5, 5, 100, 90},
            bet = {'fill', self.screenW/2-105, self.screenH/2-35, 210, 100},
            summary = {'fill', self.screenW/2-105, self.screenH/2-35, 210, 70}
        }

    end;

    drawBox = function(self, params)
        love.graphics.setColor(0,0,0,200)
        love.graphics.rectangle(unpack(params))
        love.graphics.setColor(255,255,255)
    end;

    showInfo = function(self, player)
        love.graphics.setColor(255,255,255,200)
        love.graphics.print(string.format('cash: %d\nbet: %d', player.cash, player.bet), 15,15)
        --give option to surrender immediately after deal
        if player.firstTurn then
            love.graphics.print('[w] hit\n[a] split\n[s] stay\n[d] surrender', 15, 45)
        else
            love.graphics.print('[w] hit\n[a] split\n[s] stay', 15, 45)
        end
        love.graphics.setColor(255,255,255)
    end;

    test = function(self, player)
        self:drawBox(self.boxes.bet)
        self:betInfo(player)
    end;

    betInfo = function(self, player)
        love.graphics.setColor(255,255,255,200)
        love.graphics.print(string.format('Cash: %d\tBet: %d\n\n[up] +10\t [down] -10\n[left] -100\t[right] +100\n[enter] bet', 
            player.cash, player.bet), self.betx, self.bety)
        love.graphics.setColor(255,255,255)
    end;

    outcome = function(self, result)
        love.graphics.setColor(255,255,255,200)
        if result == 0 then
            love.graphics.print('DRAW\n[press Enter to continue]',self.betx, self.bety)
        elseif result == true then
            love.graphics.print('WIN\n[press Enter to continue]',self.betx, self.bety)
        else
            love.graphics.print('LOSS\n[press Enter to continue]',self.betx, self.bety)
        end
        love.graphics.setColor(255,255,255)
    end;

    draw = function(self, game)
        if game.state == 'bet' then
            self:drawBox(self.boxes.bet)
            self:betInfo(game.player)
        elseif game.state == 'descision' then
            if game.player.firstTurn then
                params = self.boxes.descision
            else
                params = self.boxes.desSmall
            end
            self:drawBox(params)
            self:showInfo(game.player)
        elseif game.state == 'result' then
            self:drawBox(self.boxes.summary)
            self:outcome(game.won)
        end
    end
}