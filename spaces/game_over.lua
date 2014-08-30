local Engine = require('engine')

local GameOver = {}

function GameOver.new(entities)
  local systems = {
    Engine.Systems.Rendering.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return GameOver
