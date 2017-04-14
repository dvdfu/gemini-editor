local Suit = require 'modules.suit'
local Editor = require 'editor'

function love.load()
    editor = Editor()
end

function love.update(dt)
    editor:update(dt)
end

function love.textinput(t)
    Suit.textinput(t)
end

function love.mousepressed(x, y, button)
    editor:mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    editor:mousemoved(x, y)
end

function love.mousereleased(x, y, button)
    editor:mousereleased(x, y, button)
end

function love.keypressed(...)
    editor:keypressed(...)
    Suit.keypressed(...)
end

function love.draw()
    Suit.draw()
    editor:draw()
end
