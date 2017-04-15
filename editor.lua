local Class = require 'modules.middleclass.middleclass'
local Level = require 'level'
local Util = require 'util'

local Editor = Class('Editor')
Editor.TILE_SIZE = 16
Editor.SCALE = 2

function Editor:initialize()
    self.level = Level('name', Editor.TILE_SIZE, Editor.TILE_SIZE)
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
    mx = mx / Editor.SCALE
    my = my / Editor.SCALE
    local tile = self:screenCoordsToTile(mx, my)
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

function Editor:screenCoordsToTile(x, y)
    local tx = math.floor(x / Editor.TILE_SIZE) + 1
    local ty = math.floor(y / Editor.TILE_SIZE) + 1
    return self:coordsToTile(tx, ty)
end

function Editor:tileToScreenCoords(t)
    local x, y = self:tileToCoords(t)
    x = x - 1
    y = y - 1
    return x * Editor.TILE_SIZE, y * Editor.TILE_SIZE
end

function Editor:coordsToTile(x, y)
    x = Util.clamp(x, 1, self.level.width)
    y = Util.clamp(y, 1, self.level.height)
    return (y - 1) * self.level.width + x
end

function Editor:tileToCoords(t)
    local x = (t - 1) % self.level.width
    local y = (t - 1) / self.level.width
    return x + 1, math.floor(y) + 1
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
    love.graphics.scale(Editor.SCALE, Editor.SCALE)
    local layer = self.level:getLayer('solid')
    for x = 1, self.level:getWidth() do
        for y = 1, self.level:getHeight() do
            love.graphics.rectangle('line', (x - 1) * 16, (y - 1) * 16, 16, 16)
            local i = self:coordsToTile(x, y)
            if layer:getTile(i) > 0 then
                love.graphics.rectangle('fill', (x - 1) * 16, (y - 1) * 16, 16, 16)
            end
        end
    end

    local tile = self:screenCoordsToTile(love.mouse.getPosition())
    local tx, ty = self:tileToScreenCoords(self.selectedTile)
    love.graphics.rectangle('fill', tx, ty, Editor.TILE_SIZE, Editor.TILE_SIZE)

    if self.transaction then
        for tile, _ in pairs(self.transaction.tiles) do
            local tx, ty = self:tileToScreenCoords(tile)
            love.graphics.rectangle('fill', tx, ty, Editor.TILE_SIZE, Editor.TILE_SIZE)
        end
    end
end

return Editor
