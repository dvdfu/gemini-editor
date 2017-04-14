local Class = require 'modules.middleclass.middleclass'
local Level = require 'level'
local Util = require 'util'

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
        layer = 'solid',
        tiles = {},
        previous = {}
    }
    self:mousemoved(mx, my)
end

function Editor:mousemoved(mx, my)
    local tile = self:coordsToTile(mx, my)
    if self.transaction then
        self.transaction.previous[tile] = self.level:getTile('solid', tile)
        self.transaction.tiles[tile] = 1
    end
    self.selectedTile = tile
end

function Editor:mousereleased(mx, my, button)
    self:applyTransaction(self.transaction)
    self.transaction = nil
end

function Editor:keypressed(key)
    self:undoTransaction()
end

function Editor:coordsToTile(x, y)
    local tx = math.floor(x / 16) + 1
    local ty = math.floor(y / 16) + 1
    tx = Util.clamp(tx, 1, self.level.width)
    ty = Util.clamp(ty, 1, self.level.height)
    return (ty - 1) * self.level.width + tx
end

function Editor:tileToCoords(t)
    local x = (t - 1) % self.level.width
    local y = (t - 1) / self.level.width
    return x* 16, math.floor(y) * 16
end

function Editor:applyTransaction(transaction)
    table.insert(self.transactions, transaction)
    self.level:applyTransaction(transaction)
end

function Editor:undoTransaction()
    local transaction = table.remove(self.transactions)
    if not transaction then return end
    self.level:undoTransaction(transaction)
end

function Editor:draw()
    self.level:draw()

    local tile = self:coordsToTile(love.mouse.getPosition())
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
