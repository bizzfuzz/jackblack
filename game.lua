require 'card'
require 'deck'
require 'player'
require 'dealer'
require 'hud'
require 'chip'
require 'loader'

--[[TODO 
fix:
    x- bets always reset to min in descision state
    dealer logic always breaks on ace
do:
    rand color bg
    x- chips when betting
    x- update chips in place
    timer when dealer hits
]]

Game = Class
{
    init = function(self)
        self.loader = Loader()
        self.player = Player()
        self.dealer = Dealer()
        self.deck = Deck()
        self.hud = HUD()
        self.chipAmounts = {100,50,10}
        self.chips = {}

        self.betControls = {
            ['up'] = 10,
            ['down'] = -10,
            ['right'] = 100,
            ['left'] = -100
        }
        self.updateStates = {
            ['bet'] = true,
            ['result'] = true,
        }
        self.minbet = 20
        self.won = nil
        self.presstimer = 0.4
        self.runTimer = false
        self:prepareBetting()
    end;

    start = function(self) --deal state
        self.won = nil
        self.player.bust = false
        self.player.firstTurn = true
        self.dealer.set = false
        self.player:emptyHand()
        self.dealer:emptyHand()
        for i=1,2 do
            self.deck:deal(self.player, self.loader)
            self.deck:deal(self.dealer, self.loader)
        end
    end;

    prepareBetting = function(self)
        self.player.bet, self.player.lastbet = self.minbet, self.minbet
        self:getChips(self.player)
        love.keyboard.setKeyRepeat(true)
        self.state = 'bet'
    end;

    getTotal = function(self, player)
        local total = 0
        for _,card in pairs(player.hand) do
            --faces
            if card.rank > 10 then
                total = total + 10
            --aces
            elseif card.rank == 1 then
                total = total + 11
            else
                total = total + card.rank
            end
        end

        if total > 21 then
            for _,card in pairs(player.hand) do
                if card.rank == 1 then
                    total = total - 10
                    --if >1 Ace only convert what's needed
                    if total <= 21 then break end
                end
            end
        end
        return total
    end;

    getChips = function(self, player)
        self.chips = {}
        local bet = player.bet
        local count

        for _,amount in pairs(self.chipAmounts) do
            if amount <= bet then
                count = math.floor(bet/amount)
                bet = bet % amount
                for i =1,count do
                    table.insert(self.chips, Chip(amount))
                end

                if bet == 0 then break end
            end
        end
    end;

    updateChips = function(self, player)
        local diff = player.bet - player.lastbet
        
        if diff < 0 then --remove chips
            diff = math.abs(diff)
            table.sort( self.chips, function (a,b) return a.value < b.value end )
            local toremove = {}
            
            for i = #self.chips, 1, -1 do
                if self.chips[i].value <= diff then
                    diff = diff - self.chips[i].value
                    table.insert(toremove, i)

                    if diff == 0 then break end
                end
            end

            if diff == 0 then
                for _,index in pairs(toremove) do
                    table.remove(self.chips, index)
                end
            elseif diff > 0 then
                self:getChips(player)
            end
        elseif diff > 0 then --add chips
            for _,value in pairs(self.chipAmounts) do
                while diff > 0 and value <= diff do
                    table.insert(self.chips, Chip(value))
                    diff = diff - value
                end
            end
        end
    end;

    evaluate = function(self)
        local ptotal = self:getTotal(self.player)
        local dtotal = self:getTotal(self.dealer)

        if self.player.bust or (dtotal <= 21 and dtotal > ptotal) then
            self.won = false
            self.player.cash = self.player.cash - self.player.bet
        elseif dtotal > 21 or (ptotal <= 21 and ptotal > dtotal) then
            self.won = true
            self.player.cash = self.player.cash + self.player.bet
        else
            self.won = 0
        end

        self.state = 'result'
    end;
    
    draw = function(self)
        love.graphics.draw(self.loader.bg,0,0)
        if self.state == 'result' then
            love.graphics.print(string.format('%s',self.won), 10, 400)
        elseif self.state == 'descision' then
            love.graphics.print(self:getTotal(self.player), 10,130)
        end
        if self.state ~= 'bet' then
            self.player:draw(self.loader)
            if self.state == 'descision' then
                self.dealer:draw(self.loader, true)
            else
                self.dealer:draw(self.loader)
            end
            --love.graphics.print(self:getTotal(self.dealer), 10,150)
        else
            love.graphics.print(self.presstimer, 10,150)
        end
        
        for _,chip in pairs(self.chips) do
            chip:draw(self.loader)
        end
        
        self.hud:draw(self, self.player)
        love.graphics.print(self.state, 10,110)
    end;
    
    keypressed = function(self, key)
        if key == 'escape' then
            love.event.push('quit')
        end

        if self.state == 'bet' then
            if self.betControls[key] then
                self.presstimer = 0.4
                self.runTimer = true
                local tempbet = self.player.bet + self.betControls[key]

                if tempbet >= self.minbet and tempbet <= self.player.cash then
                    self.player.bet = tempbet
                    --self:getChips(self.player)
                end
            end
            
            if key == 'return' then
                self:start()
                love.keyboard.setKeyRepeat(false)
                
                if self:getTotal(self.player) == 21 then
                    self.dealer:logic(self)
                    self:evaluate()
                    self.state = 'result'
                else
                    self.state = 'descision'
                end
            end
        end

        if self.state == 'descision' then
            if key == 'w' then --hit
                self.deck:deal(self.player, self.loader)
                if self:getTotal(self.player) > 21 then
                    self.player.bust = true
                    self.dealer:logic(self)
                    self:evaluate()
                    self.state = 'result'
                end
                self.player.firstTurn = false
            end

            if key == 's' or (self.player.firstTurn and key == 'd') then --stay/surrender
                if key == 'd' then
                    self.player.bet = math.floor(self.player.bet/2)
                end
                self.dealer:logic(self)
                self:evaluate()
                self.state = 'result'
            end
        end

        if self.state == 'result' and key == 'return' then
            self:prepareBetting()
        end
    end;

    update = function(self, dt)
        if self.state == 'bet' then
            if self.presstimer <= 0 then
                self:updateChips(self.player)
                self.player.lastbet = self.player.bet
                self.runTimer = false
                self.presstimer = 0.4
            else
                if self.runTimer then
                    self.presstimer = self.presstimer - dt
                end
            end
        elseif self.state == 'result' then
            for i,chip in ipairs(self.chips) do
                chip:leave(dt, self.won)
                if chip.left then
                    table.remove(self.chips, i)
                end
            end
        end
    end;

    updateToggle = function(self, dt)
        if self.updateStates[self.state] then
            self:update(dt)
        end
    end;
}
