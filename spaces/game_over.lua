local Engine = require('engine')

local RestartSystem = require('systems.restart')

local GameOver = {}

function GameOver.new(entities)
  local systems = {
    Engine.Systems.Rendering.new(entities),
    RestartSystem.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return GameOver
