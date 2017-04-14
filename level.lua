local Class = require 'modules.middleclass.middleclass'

local Layer = Class('Layer')

function Layer:initialize(width, height)
    self.width = width
    self.height = height
    self.tiles = {}
    for y = 1, height do
        local row = {}
        for x = 1, width do
            row[x] = -1
        end
        self.tiles[y] = row
    end
end

function Layer:setTile(x, y, tile)
    assert(x > 0 and x <= self.width)
    assert(y > 0 and y <= self.height)
    self.tiles[y][x] = tile
end

function Layer:getTile()
    assert(x > 0 and x <= self.width)
    assert(y > 0 and y <= self.height)
    return self.tiles[y][x]
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
    self.activeLayer = self.layers.solid
end

function Level:update(dt)
end

function Level:draw()
end

return Level
