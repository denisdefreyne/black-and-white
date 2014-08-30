local Engine = require('engine')

local Arena = {}

local InputSystem = require('systems.input')
local OffscreenSystem = require('systems.offscreen')
local EnemySpawner = require('systems.enemy_spawner')

function Arena.new(entities)
  local systems = {
    InputSystem.new(entities),
    OffscreenSystem.new(entities),
    EnemySpawner.new(entities),
    Engine.Systems.Rendering.new(entities),
    Engine.Systems.Physics.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return Arena
