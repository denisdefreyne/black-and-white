local Engine = require('engine')
local Components = require('components')
local Gamestate = require('engine.vendor.hump.gamestate')

local Prefabs = {}

function Prefabs.createHit(isBig, x, y, entities)
  local imagePath = 'assets/bullet.png'
  local config = {
    position               = { 0, 0 },
    offset                 = { 0, 0 },
    bufferSize             = isBig and 400 or 10,
    emissionRate           = 100000,
    emitterLifetime        = isBig and 0.3 or 0.1,
    particleLifetime       = { 0.2, 1.0 },
    colors                 = {
                               255, 0, 0, 255,
                               255, 0, 0,   0,
                             },
    sizes                  = { 0.1, 0.1 },
    sizeVariation          = 1,
    speed                  = { 0, 250 },
    direction              = 3 * math.pi / 2,
    spread                 = math.pi * 2,
    linearAcceleration     = { 0, 200, 0, 800 },
    rotation               = { 0, 0 },
    spin                   = { 0, 0, 0 },
    radialAcceleration     = 0,
    tangentialAcceleration = 0.0,
  }

  local self = Engine.Entity.new()

  self:add(Engine.Components.Z,              1)
  self:add(Engine.Components.ParticleSystem, imagePath, config, true)
  self:add(Engine.Components.Position, x, y)
  self:add(Engine.Components.Timewarp     )

  return self
end

function Prefabs.createBackground()
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
    entities:add(Prefabs.createHit(true, pos.x, pos.y))

    health.cur = health.cur - 1
  end
end

local function gameOver()
  local GameOverState = require('gamestates.game_over')
  Gamestate.switch(GameOverState.new())
end

local PLAYER_OFFSET_X = 80

function Prefabs.createBlackPlayer()
  local animationImagePaths = {
    'assets/black_bird_idleanim_1.png',
    'assets/black_bird_idleanim_2.png',
    'assets/black_bird_idleanim_3.png',
    'assets/black_bird_idleanim_4.png',
    'assets/black_bird_idleanim_5.png',
  }

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, PLAYER_OFFSET_X, love.window.getHeight() / 2)
  e:add(Components.BlackPlayer)
  e:add(Components.Gun)
  e:add(Components.CollisionGroup, 'black')
  e:add(Components.Health, 5)
  e:add(Components.OnDeath, gameOver)
  e:add(Engine.Components.OnCollide, playerCollided)
  e:add(Engine.Components.Rotation, math.pi)
  e:add(Engine.Components.Velocity, 0, 0)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Animation, animationImagePaths, 0.15)
  return e
end

function Prefabs.createWhitePlayer()
  local animationImagePaths = {
    'assets/white_bird_idleanim_1.png',
    'assets/white_bird_idleanim_2.png',
    'assets/white_bird_idleanim_3.png',
    'assets/white_bird_idleanim_4.png',
    'assets/white_bird_idleanim_5.png',
  }

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() - PLAYER_OFFSET_X, love.window.getHeight() / 2)
  e:add(Components.WhitePlayer)
  e:add(Components.Gun)
  e:add(Components.CollisionGroup, 'white')
  e:add(Components.Health, 5)
  e:add(Components.OnDeath, gameOver)
  e:add(Engine.Components.OnCollide, playerCollided)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Velocity, 0, 0)
  e:add(Engine.Components.Animation, animationImagePaths, 0.15)
  return e
end

function Prefabs.createEnemySpawner()
  local e = Engine.Entity.new()
  e:add(Components.EnemySpawner)
  return e
end

function Prefabs.createHealthBar(player, isBlack)
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

local BULLET_VELOCITY_X = 400

local function bulletCollided(entity, otherEntity, entities)
  local originatingEntityCmp = entity:get(Components.OriginatingEntity)
  if originatingEntityCmp and originatingEntityCmp.entity ~= otherEntity then
    local pos = entity:get(Engine.Components.Position)
    local hit = Prefabs.createHit(false, pos.x, pos.y, entities)
    entities:add(hit)
    entities:remove(entity)
  end
end

function Prefabs.createBullet(entities, isBlack)
  local animationImagePaths = {
    'assets/bullet_idleanim_1.png',
    'assets/bullet_idleanim_2.png',
    'assets/bullet_idleanim_3.png',
    'assets/bullet_idleanim_4.png',
    'assets/bullet_idleanim_5.png',
  }

  local whitePlayer = entities:firstWithComponent(Components.WhitePlayer)
  local blackPlayer = entities:firstWithComponent(Components.BlackPlayer)

  local whitePosition = whitePlayer:get(Engine.Components.Position)
  local blackPosition = blackPlayer:get(Engine.Components.Position)

  local position  = isBlack and blackPosition or whitePosition
  local imagePath = 'assets/bullet.png'
  local xVelocity = isBlack and BULLET_VELOCITY_X or -BULLET_VELOCITY_X
  local rotation  = isBlack and math.pi or 0
  local originatingEntity = isBlack and blackPlayer or whitePlayer

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, position.x, position.y)
  e:add(Engine.Components.Velocity, xVelocity, 0)
  e:add(Engine.Components.Z, -1)
  e:add(Engine.Components.Scale, 0.3)
  e:add(Engine.Components.Rotation, rotation)
  e:add(Engine.Components.OnCollide, bulletCollided)
  e:add(Components.Bullet)
  e:add(Components.CollisionGroup, 'bullet')
  e:add(Components.OriginatingEntity, originatingEntity)
  e:add(Engine.Components.Animation, animationImagePaths, 0.08)
  return e
end

local ENEMY_VELOCITY_X = 100
local ENEMY_OFFSET_X   = 20
local ENEMY_OFFSET_Y   = 150

local function enemyCollided(entity, otherEntity, entities)
  if otherEntity:get(Components.Bullet) then
    local pos = entity:get(Engine.Components.Position)
    local hit = Prefabs.createHit(false, pos.x, pos.y, entities)
    entities:add(hit)
    entities:remove(entity)
  end
end

function Prefabs.createEnemy(isBlack)
  local whiteAnimationImagePaths = {
    'assets/white_enemy_idleanim_1.png',
    'assets/white_enemy_idleanim_2.png',
    'assets/white_enemy_idleanim_3.png',
    'assets/white_enemy_idleanim_4.png',
    'assets/white_enemy_idleanim_5.png',
  }

  local blackAnimationImagePaths = {
    'assets/black_enemy_idleanim_1.png',
    'assets/black_enemy_idleanim_2.png',
    'assets/black_enemy_idleanim_3.png',
    'assets/black_enemy_idleanim_4.png',
    'assets/black_enemy_idleanim_5.png',
  }

  local animationImagePaths = isBlack and whiteAnimationImagePaths or blackAnimationImagePaths

  local xVelocity = isBlack and ENEMY_VELOCITY_X or -ENEMY_VELOCITY_X
  local imagePath = animationImagePaths[1]

  local x = isBlack and - ENEMY_OFFSET_X or love.window.getWidth() + ENEMY_OFFSET_X
  local y = ENEMY_OFFSET_Y + math.random() * (love.window.getHeight() - 2 * ENEMY_OFFSET_Y)

  local xScale = isBlack and 0.6 or -0.6
  local yScale = -0.6

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, x, y)
  e:add(Engine.Components.Velocity, xVelocity, 0)
  e:add(Engine.Components.Z, 1)
  e:add(Engine.Components.Scale, xScale, yScale)
  e:add(Engine.Components.Size, 160, 90)
  e:add(Engine.Components.OnCollide, enemyCollided)
  e:add(Components.CollisionGroup, 'enemy')
  e:add(Engine.Components.Animation, animationImagePaths, 0.15)
  e:add(Components.EnemyBehavior)
  return e
end

return Prefabs
