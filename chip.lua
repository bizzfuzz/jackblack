Chip = Class
{
    init = function(self, amount)
        self.x, self.y = math.random(10,250), math.random(200,440)
        self.value = amount
        self.speed= 350
        self.left = false
    end;

    draw = function(self, loader)
        love.graphics.draw(loader.chips[self.value], self.x, self.y)
    end;

    leave = function(self, dt, win)
        if win == 0 then
            self.x = self.x - self.speed * dt

            if self.x < -80 then
                self.left = true
            end
        elseif win then
            self.y = self.y + self.speed * dt

            if self.y > 1000 then
                self.left = true
            end
        else
            self.y = self.y - self.speed * dt

            if self.y < -80 then
                self.left = true
            end
        end
    end;
}