local Engine = require('engine')

local Arena = {}

local InputSystem             = require('systems.input')
local OffscreenSystem         = require('systems.offscreen')
local EnemySpawner            = require('systems.enemy_spawner')
local CollisionHandlingSystem = require('systems.collision_handling')
local GameOverSystem          = require('systems.game_over')
local EnemyBehaviorSystem     = require('systems.enemy_behavior')

function Arena.new(entities)
  local systems = {
    InputSystem.new(entities),
    Engine.Systems.Animation.new(entities),
    OffscreenSystem.new(entities),
    EnemySpawner.new(entities),
    EnemyBehaviorSystem.new(entities),
    Engine.Systems.CollisionDetection.new(entities),
    CollisionHandlingSystem.new(entities),
    Engine.Systems.ParticleSystem.new(entities),
    Engine.Systems.Rendering.new(entities),
    Engine.Systems.Physics.new(entities),
    GameOverSystem.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

return Arena
