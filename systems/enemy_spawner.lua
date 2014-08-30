local Signal = require('engine.vendor.hump.signal')
local Engine = require('engine')

local EnemySpawner = Engine.System.newType()

local Components = require('components')

function EnemySpawner.new(entities)
  local requiredComponentTypes = {
    Components.EnemySpawner,
  }

  return Engine.System.new(EnemySpawner, entities, requiredComponentTypes)
end

local ENEMY_VELOCITY_X = 100
local ENEMY_OFFSET_X   = 20
local ENEMY_OFFSET_Y   = 20

local function createEnemy(isBlack)
  local whiteAnimationImagePaths = {
    'assets/real/white_enemy_idleanim_1.png',
    'assets/real/white_enemy_idleanim_2.png',
    'assets/real/white_enemy_idleanim_3.png',
    'assets/real/white_enemy_idleanim_4.png',
    'assets/real/white_enemy_idleanim_5.png',
  }

  local blackAnimationImagePaths = {
    'assets/real/black_enemy_idleanim_1.png',
    'assets/real/black_enemy_idleanim_2.png',
    'assets/real/black_enemy_idleanim_3.png',
    'assets/real/black_enemy_idleanim_4.png',
    'assets/real/black_enemy_idleanim_5.png',
  }

  local animationImagePaths = isBlack and whiteAnimationImagePaths or blackAnimationImagePaths

  local xVelocity = isBlack and ENEMY_VELOCITY_X or -ENEMY_VELOCITY_X
  local imagePath = isBlack and 'assets/enemy-white.png' or 'assets/enemy-black.png'

  local x = isBlack and - ENEMY_OFFSET_X or love.window.getWidth() + ENEMY_OFFSET_X
  local y = ENEMY_OFFSET_Y + math.random() * (love.window.getHeight() - 2 * ENEMY_OFFSET_Y)

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, x, y)
  e:add(Engine.Components.Velocity, xVelocity, 0)
  e:add(Engine.Components.Z, 1)
  e:add(Engine.Components.Scale, 0.6)
  e:add(Engine.Components.Image, imagePath)
  e:add(Components.CollisionGroup, 'enemy')
  e:add(Components.Animation, animationImagePaths, 0.15)
  return e
end

function EnemySpawner:updateEntity(entity, dt)
  local enemySpawnerComponent = entity:get(Components.EnemySpawner)

  if enemySpawnerComponent.curCooldown <= 0 then
    self.entities:add(createEnemy(true))
    self.entities:add(createEnemy(false))

    enemySpawnerComponent.curCooldown = enemySpawnerComponent.curCooldown + enemySpawnerComponent.maxCooldown
  end

  enemySpawnerComponent.curCooldown = enemySpawnerComponent.curCooldown - dt
end

return EnemySpawner
