local Engine = require('engine')

local Gamestate = require('engine.vendor.hump.gamestate')

local Components = require('components')
local Prefabs = require('prefabs')

local Input = {}
Input.__index = Input

function Input.new(entities)
  return setmetatable({ entities = entities }, Input)
end

local SCREEN_OFFSET = 100

local function shoot(entities, whitePlayer, dt)
  local gunComponent = whitePlayer:get(Components.Gun)

  if love.keyboard.isDown(" ") and gunComponent.curCooldown <= 0 then
    entities:add(Prefabs.createBullet(entities, true))
    entities:add(Prefabs.createBullet(entities, false))

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
