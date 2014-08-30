local Signal = require('engine.vendor.hump.signal')
local Engine_Components = require('engine.components')
local Engine_System     = require('engine.system')

local Offscreen = Engine_System.newType()

local Components = require('components')

function Offscreen.new(entities)
  local requiredComponentTypes = {
    Engine_Components.Position,
    Engine_Components.Velocity,
  }

  return Engine_System.new(Offscreen, entities, requiredComponentTypes)
end

function Offscreen:updateEntity(entity, dt)
  local position = entity:get(Engine_Components.Position)
  local velocity = entity:get(Engine_Components.Velocity)

  local blackPlayer = self.entities:firstWithComponent(Components.BlackPlayer)
  local whitePlayer = self.entities:firstWithComponent(Components.WhitePlayer)

  local blackHealth = blackPlayer:get(Components.Health)
  local whiteHealth = whitePlayer:get(Components.Health)

  local collisionGroup = entity:get(Components.CollisionGroup)

  if position.x < 0 and velocity.x <= 0 then
    self.entities:remove(entity)
    if collisionGroup.name == 'enemy' then
      blackHealth.cur = blackHealth.cur - 1
    end
    return
  end

  if position.x > love.window.getWidth() and velocity.x >= 0 then
    self.entities:remove(entity)
    if collisionGroup.name == 'enemy' then
      whiteHealth.cur = whiteHealth.cur - 1
    end
    return
  end
end

return Offscreen
