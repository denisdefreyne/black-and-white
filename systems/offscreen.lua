local Signal = require('engine.vendor.hump.signal')
local Engine_Components = require('engine.components')
local Engine_System     = require('engine.system')

local Offscreen = Engine_System.newType()

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

  if position.x < 0 and velocity.x <= 0 then
    self.entities:remove(entity)
    return
  end

  if position.x > love.window.getWidth() and velocity.x >= 0 then
    self.entities:remove(entity)
    return
  end
end

return Offscreen
