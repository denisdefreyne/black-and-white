local Engine = require('engine')

local Arena = {}

local InputSystem             = require('systems.input')
local OffscreenSystem         = require('systems.offscreen')
local EnemySpawner            = require('systems.enemy_spawner')
local CollisionHandlingSystem = require('systems.collision_handling')

function Arena.new(entities)
  local systems = {
    InputSystem.new(entities),
    OffscreenSystem.new(entities),
    EnemySpawner.new(entities),
    Engine.Systems.CollisionDetection.new(entities),
    CollisionHandlingSystem.new(entities),
    Engine.Systems.Rendering.new(entities),
    Engine.Systems.Physics.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return Arena
