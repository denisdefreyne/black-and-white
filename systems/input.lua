local Engine = require('engine')
local Debugger = require('debugger')

local Gamestate = require('engine.vendor.hump.gamestate')

local Components = require('components')

local Input = {}
Input.__index = Input

function Input.new(entities)
  return setmetatable({ entities = entities }, Input)
end

local BULLET_VELOCITY_X = 200
local SCREEN_OFFSET = 50

local function createBullet(entities, isBlack)
  local animationImagePaths = {
    'assets/real/bullet_idleanim_1.png',
    'assets/real/bullet_idleanim_2.png',
    'assets/real/bullet_idleanim_3.png',
    'assets/real/bullet_idleanim_4.png',
    'assets/real/bullet_idleanim_5.png',
  }

  local whitePlayer = entities:firstWithComponent(Components.WhitePlayer)
  local blackPlayer = entities:firstWithComponent(Components.BlackPlayer)

  local whitePosition = whitePlayer:get(Engine.Components.Position)
  local blackPosition = blackPlayer:get(Engine.Components.Position)

  local position  = isBlack and blackPosition or whitePosition
  local imagePath = 'assets/real/bullet.png'
  local xVelocity = isBlack and BULLET_VELOCITY_X or -BULLET_VELOCITY_X
  local rotation  = isBlack and math.pi or 0
  local originatingEntity = isBlack and blackPlayer or whitePlayer

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, position.x, position.y)
  e:add(Engine.Components.Velocity, xVelocity, 0)
  e:add(Engine.Components.Z, -1)
  e:add(Engine.Components.Scale, 0.3)
  e:add(Engine.Components.Image, imagePath)
  e:add(Engine.Components.Rotation, rotation)
  e:add(Components.CollisionGroup, 'bullet')
  e:add(Components.OriginatingEntity, originatingEntity)
  e:add(Components.Animation, animationImagePaths, 0.08)
  return e
end

local function shoot(entities, whitePlayer, dt)
  local gunComponent = whitePlayer:get(Components.Gun)

  if gunComponent.curCooldown <= 0 then
    entities:add(createBullet(entities, true))
    entities:add(createBullet(entities, false))

    gunComponent.curCooldown = gunComponent.curCooldown + gunComponent.maxCooldown
  end

  gunComponent.curCooldown = gunComponent.curCooldown - dt
end

function Input:update(dt)
  local whitePlayer = self.entities:firstWithComponent(Components.WhitePlayer)
  local blackPlayer = self.entities:firstWithComponent(Components.BlackPlayer)

  local whitePosition = whitePlayer:get(Engine.Components.Position)
  local blackPosition = blackPlayer:get(Engine.Components.Position)

  local speed = 600*dt

  local lk = love.keyboard

  if lk.isDown("up") and blackPosition.y > SCREEN_OFFSET then
    whitePosition.y = whitePosition.y + speed
    blackPosition.y = blackPosition.y - speed
  end

  if lk.isDown("down") and whitePosition.y > SCREEN_OFFSET then
    whitePosition.y = whitePosition.y - speed
    blackPosition.y = blackPosition.y + speed
  end

  if lk.isDown(" ") then
    shoot(self.entities, whitePlayer, dt)
  end
end

return Input
