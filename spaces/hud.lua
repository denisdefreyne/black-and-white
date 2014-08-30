local Engine = require('engine')

local HealthTrackingSystem = require('systems.health_tracking')

local HUD = {}

function HUD.new(entities)
  local systems = {
    Engine.Systems.Rendering.new(entities),
    HealthTrackingSystem.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return HUD
