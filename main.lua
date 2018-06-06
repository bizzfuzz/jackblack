Class = require 'class'
require 'game'

local game

function love.load ()
    math.randomseed(os.time())
    game = Game()
end

function love.update (dt)
    game:updateToggle(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    game:keypressed(key)
end
