local Engine   = require('engine')

local Components = require('components')

local InputSystem             = require('systems.input')
local OffscreenSystem         = require('systems.offscreen')
local EnemySpawner            = require('systems.enemy_spawner')
local GameOverSystem          = require('systems.game_over')
local EnemyBehaviorSystem     = require('systems.enemy_behavior')
local HealthTrackingSystem    = require('systems.health_tracking')

local HitPrefab = require('prefabs.hit')

local Main = {}

local xOffset = 80

local function createBackground()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() / 2, love.window.getHeight() / 2)
  e:add(Engine.Components.Z, -100)
  e:add(Engine.Components.Image, 'assets/background.jpg')
  return e
end

local function playerCollided(entity, otherEntity, entities)
  local pos = entity:get(Engine.Components.Position)
  local otherOriginatingEntityCmp = otherEntity:get(Components.OriginatingEntity)
  local health = entity:get(Components.Health)

  if otherOriginatingEntityCmp and otherOriginatingEntityCmp.entity ~= entity then
    entities:add(HitPrefab.new(true, pos.x, pos.y))

    health.cur = health.cur - 1
  end
end

local function createBlackPlayer()
  local animationImagePaths = {
    'assets/black_bird_idleanim_1.png',
    'assets/black_bird_idleanim_2.png',
    'assets/black_bird_idleanim_3.png',
    'assets/black_bird_idleanim_4.png',
    'assets/black_bird_idleanim_5.png',
  }

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, xOffset, love.window.getHeight() / 2)
  e:add(Components.BlackPlayer)
  e:add(Components.Gun)
  e:add(Components.CollisionGroup, 'black')
  e:add(Components.Health, 5)
  e:add(Engine.Components.OnCollide, playerCollided)
  e:add(Engine.Components.Rotation, math.pi)
  e:add(Engine.Components.Velocity, 0, 0)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Animation, animationImagePaths, 0.15)
  return e
end

local function createWhitePlayer()
  local animationImagePaths = {
    'assets/white_bird_idleanim_1.png',
    'assets/white_bird_idleanim_2.png',
    'assets/white_bird_idleanim_3.png',
    'assets/white_bird_idleanim_4.png',
    'assets/white_bird_idleanim_5.png',
  }

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() - xOffset, love.window.getHeight() / 2)
  e:add(Components.WhitePlayer)
  e:add(Components.Gun)
  e:add(Components.CollisionGroup, 'white')
  e:add(Components.Health, 5)
  e:add(Engine.Components.OnCollide, playerCollided)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Velocity, 0, 0)
  e:add(Engine.Components.Animation, animationImagePaths, 0.15)
  return e
end

local function createEnemySpawner()
  local e = Engine.Entity.new()
  e:add(Components.EnemySpawner)
  return e
end

local function createHealthBar(player, isBlack)
  local x = isBlack and 90 or love.window.getWidth() - 110
  local y = 60

  local e = Engine.Entity.new()
  e:add(Engine.Components.Image, 'assets/life_5.png')
  e:add(Engine.Components.Position, x, y)
  e:add(Engine.Components.Z, 100)
  e:add(Engine.Components.Scale, 0.8)
  e:add(Components.HealthTracking, player)
  return e
end

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
  local blackPlayer = createBlackPlayer()
  local whitePlayer = createWhitePlayer()

  local arenaEntities = Engine.Types.EntitiesCollection:new()
  arenaEntities:add(createBackground())
  arenaEntities:add(blackPlayer)
  arenaEntities:add(whitePlayer)
  arenaEntities:add(createEnemySpawner())
  local arenaSpace = createArenaSpace(arenaEntities)

  local hudEntities = Engine.Types.EntitiesCollection:new()
  hudEntities:add(createHealthBar(blackPlayer, true))
  hudEntities:add(createHealthBar(whitePlayer, false))
  local hudSpace = createHUDSpace(hudEntities)

  return Engine.Gamestate.new({ hudSpace, arenaSpace })
end

return Main
