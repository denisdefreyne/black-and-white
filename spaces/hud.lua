local Engine = require('engine')

local HUD = {}

function HUD.new(entities)
  local systems = {
    Engine.Systems.Rendering.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return HUD
