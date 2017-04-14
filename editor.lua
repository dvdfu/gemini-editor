local Class = require 'modules.middleclass.middleclass'
local Level = require 'level'

local Editor = Class('Editor')

function Editor:initialize()
    self.level = Level('name', 16, 16)
    self.tiles = {}
    for i = 1, self.level.height * self.level.width do
        self.tiles[i] = -1
    end
    self.selectedTile = 1

    self.transaction = nil
    self.transactions = {}
end

function Editor:update(dt)
    self.level:update(dt)
end

function Editor:mousepressed(mx, my, button)
    self.transaction = {
        layer = self.level.activeLayer,
        tiles = {}
    }
    self:mousemoved(mx, my)
end

function Editor:mousemoved(mx, my)
    self.selectedTile = self:coordsToTile(mx, my)
    if self.transaction then
        print(self.selectedTile)
        self.transaction.tiles[self.selectedTile] = true
    end
end

function Editor:mousereleased(mx, my, button)
    table.insert(self.transactions, self.transaction)
    self.transaction = nil
end

function Editor:coordsToTile(x, y)
    local tx = math.floor(x / 16) + 1
    local ty = math.floor(y / 16) + 1
    assert(tx > 0 and tx <= self.level.width)
    assert(ty > 0 and ty <= self.level.height)
    return (ty - 1) * self.level.width + tx
end

function Editor:tileToCoords(t)
    local x = (t - 1) % self.level.width
    local y = (t - 1) / self.level.width
    return x* 16, math.floor(y) * 16
end

function Editor:draw()
    for x = 1, self.level.width do
        for y = 1, self.level.height do
            love.graphics.rectangle('line', (x - 1) * 16, (y - 1) * 16, 16, 16)
        end
    end

    local tile = self:coordsToTile(love.mouse.getPosition)
    local tx, ty = self:tileToCoords(self.selectedTile)
    love.graphics.rectangle('fill', tx, ty, 16, 16)

    if self.transaction then
        for tile, _ in pairs(self.transaction.tiles) do
            local tx, ty = self:tileToCoords(tile)
            love.graphics.rectangle('fill', tx, ty, 16, 16)
        end
    end
end

return Editor
