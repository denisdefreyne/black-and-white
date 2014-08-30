local Signal = require('engine.vendor.hump.signal')
local Engine = require('engine')

local EnemyBehavior = Engine.System.newType()

local Components = require('components')

function EnemyBehavior.new(entities)
  local requiredComponentTypes = {
    Engine.Components.Position,
    Engine.Components.Velocity,
    Components.EnemyBehavior,
  }

  return Engine.System.new(EnemyBehavior, entities, requiredComponentTypes)
end

local MAX_VELOCITY_Y = 100

function EnemyBehavior:updateEntity(entity, dt)
  local position = entity:get(Engine.Components.Position)
  local velocity = entity:get(Engine.Components.Velocity)
  local enemyBehavior = entity:get(Components.EnemyBehavior)

  local rotation = entity:get(Engine.Components.Rotation)
  if not rotation then
    entity:add(Engine.Components.Rotation, 0)
    rotation = entity:get(Engine.Components.Rotation)
  end

  local oldAngle = velocity:angle()
  velocity.y = math.sin(enemyBehavior.lifetime) * MAX_VELOCITY_Y
  local newAngle = velocity:angle()

  rotation.value = rotation.value - (oldAngle - newAngle)

  enemyBehavior.lifetime = enemyBehavior.lifetime + dt
end

return EnemyBehavior
