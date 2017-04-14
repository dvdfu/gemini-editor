local Class = require 'modules.middleclass.middleclass'

local Layer = Class('Layer')

function Layer:initialize(width, height)
    self.width = width
    self.height = height
    self.tiles = {}
    for i = 1, width * height do
        self.tiles[i] = -1
    end
end

function Layer:setTiles(tiles, type)
    for i in pairs(tiles) do
        self:setTile(i, type)
    end
end

function Layer:setTile(i, type)
    assert(i > 0 and i <= self.width * self.height)
    self.tiles[i] = type
end

function Layer:getTile(i)
    assert(i > 0 and i <= self.width * self.height)
    return self.tiles[i]
end

local Level = Class('Level')

function Level:initialize(name, width, height)
    self.name = name
    self.width = width
    self.height = height

    self.layers = {
        solid = Layer(width, height),
        object = Layer(width, height),
        decor1 = Layer(width, height),
        decor2 = Layer(width, height),
    }
end

function Level:update(dt)
end

function Level:applyTransaction(transaction)
    for i, type in pairs(transaction.tiles) do
        self.layers[transaction.layer]:setTile(i, type)
    end
end

function Level:undoTransaction(transaction)
    for i, type in pairs(transaction.previous) do
        self.layers[transaction.layer]:setTile(i, type)
    end
end

function Level:getTile(layer, i)
    return self.layers[layer]:getTile(i)
end

function Level:draw()
    for x = 1, self.width do
        for y = 1, self.height do
            love.graphics.rectangle('line', (x - 1) * 16, (y - 1) * 16, 16, 16)

            if self.layers.solid:getTile((y - 1) * self.width + x) > 0 then
                love.graphics.rectangle('fill', (x - 1) * 16, (y - 1) * 16, 16, 16)
            end
        end
    end
end

return Level
