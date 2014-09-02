local Engine   = require('engine')

local Components = require('components')

local InputSystem             = require('systems.input')
local OffscreenSystem         = require('systems.offscreen')
local EnemySpawner            = require('systems.enemy_spawner')
local GameOverSystem          = require('systems.game_over')
local EnemyBehaviorSystem     = require('systems.enemy_behavior')
local HealthTrackingSystem    = require('systems.health_tracking')

local Prefabs = require('prefabs')

local Main = {}

local function createArenaSpace(entities)
  local systems = {
    InputSystem.new(entities),
    Engine.Systems.Animation.new(entities),
    OffscreenSystem.new(entities),
    EnemySpawner.new(entities),
    EnemyBehaviorSystem.new(entities),
    Engine.Systems.CollisionDetection.new(entities),
    Engine.Systems.ParticleSystem.new(entities),
    Engine.Systems.Rendering.new(entities),
    Engine.Systems.Physics.new(entities),
    GameOverSystem.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

local function createHUDSpace(entities)
  local systems = {
    Engine.Systems.Rendering.new(entities),
    HealthTrackingSystem.new(entities),
  }

  return Engine.Space.new(entities, systems)
end

function Main.new()
  local blackPlayer = Prefabs.createBlackPlayer()
  local whitePlayer = Prefabs.createWhitePlayer()

  local arenaEntities = Engine.Types.EntitiesCollection:new()
  arenaEntities:add(Prefabs.createBackground())
  arenaEntities:add(blackPlayer)
  arenaEntities:add(whitePlayer)
  arenaEntities:add(Prefabs.createEnemySpawner())
  local arenaSpace = createArenaSpace(arenaEntities)

  local hudEntities = Engine.Types.EntitiesCollection:new()
  hudEntities:add(Prefabs.createHealthBar(blackPlayer, true))
  hudEntities:add(Prefabs.createHealthBar(whitePlayer, false))
  local hudSpace = createHUDSpace(hudEntities)

  return Engine.Gamestate.new({ hudSpace, arenaSpace })
end

return Main
