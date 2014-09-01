local Engine = require('engine')

local Components    = require('components')
local RestartSystem = require('systems.restart')

local GameOver = {}

local function createBackground()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() / 2, love.window.getHeight() / 2)
  e:add(Engine.Components.Z, -100)
  e:add(Engine.Components.Image, 'assets/endscreen.jpg')
  return e
end

local function createSpace(entities)
  local systems = {
    Engine.Systems.Rendering.new(entities),
    RestartSystem.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

function GameOver.new()
  local entities = Engine.Types.EntitiesCollection:new()
  entities:add(createBackground())
  local gameOverSpace = createSpace(entities)

  return Engine.Gamestate.new({ gameOverSpace })
end

return GameOver
