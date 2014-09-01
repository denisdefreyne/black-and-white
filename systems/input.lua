local Engine = require('engine')

local Gamestate = require('engine.vendor.hump.gamestate')

local Components = require('components')
local HitPrefab = require('prefabs.hit')

local Input = {}
Input.__index = Input

function Input.new(entities)
  return setmetatable({ entities = entities }, Input)
end

local BULLET_VELOCITY_X = 400
local SCREEN_OFFSET = 100

local function bulletCollided(entity, otherEntity, entities)
  local originatingEntityCmp = entity:get(Components.OriginatingEntity)
  if originatingEntityCmp and originatingEntityCmp.entity ~= otherEntity then
    local pos = entity:get(Engine.Components.Position)
    local hit = HitPrefab.new(false, pos.x, pos.y, entities)
    entities:add(hit)
    entities:remove(entity)
  end
end

local function createBullet(entities, isBlack)
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

local function shoot(entities, whitePlayer, dt)
  local gunComponent = whitePlayer:get(Components.Gun)

  if love.keyboard.isDown(" ") and gunComponent.curCooldown <= 0 then
    entities:add(createBullet(entities, true))
    entities:add(createBullet(entities, false))

    gunComponent.curCooldown = gunComponent.curCooldown + gunComponent.maxCooldown
  end

  gunComponent.curCooldown = gunComponent.curCooldown - dt
  if gunComponent.curCooldown < 0 then gunComponent.curCooldown = 0 end
end

function Input:update(dt)
  local whitePlayer = self.entities:firstWithComponent(Components.WhitePlayer)
  local blackPlayer = self.entities:firstWithComponent(Components.BlackPlayer)

  local whitePosition = whitePlayer:get(Engine.Components.Position)
  local blackPosition = blackPlayer:get(Engine.Components.Position)

  local whiteVelocity = whitePlayer:get(Engine.Components.Velocity)
  local blackVelocity = blackPlayer:get(Engine.Components.Velocity)

  local rawSpeed = 600
  local speed = rawSpeed*dt

  if love.keyboard.isDown("up") and blackPosition.y > SCREEN_OFFSET then
    whiteVelocity.y = rawSpeed
    blackVelocity.y = -rawSpeed
  elseif love.keyboard.isDown("down") and whitePosition.y > SCREEN_OFFSET then
    whiteVelocity.y = -rawSpeed
    blackVelocity.y = rawSpeed
  else
    whiteVelocity.y = whiteVelocity.y * 0.8
    blackVelocity.y = blackVelocity.y * 0.8
  end

  shoot(self.entities, whitePlayer, dt)
end

return Input
