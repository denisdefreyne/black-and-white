local Engine = require('engine')

local Arena = {}

local InputSystem = require('systems.input')

function Arena.new(entities)
  local systems = {
    InputSystem.new(entities),
    Engine.Systems.Rendering.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return Arena
