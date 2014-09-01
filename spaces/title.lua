local Engine = require('engine')

local RestartSystem = require('systems.restart')

local Title = {}

function Title.new(entities)
  local systems = {
    Engine.Systems.Rendering.new(entities),
    Engine.Systems.CursorTracking.new(entities),
    RestartSystem.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return Title
