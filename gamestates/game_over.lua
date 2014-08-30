local Engine = require('engine')

local GameOverSpace = require('spaces.game_over')
local Components    = require('components')

local GameOver = {}

local function createBackground()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() / 2, love.window.getHeight() / 2)
  e:add(Engine.Components.Z, -100)
  e:add(Engine.Components.Image, 'assets/endscreen.jpg')
  return e
end

function GameOver.new()
  local entities = Engine.Types.EntitiesCollection.new()
  entities:add(createBackground())
  local gameOverSpace = GameOverSpace.new(entities)

  return Engine.Gamestate.new({ gameOverSpace })
end

return GameOver
