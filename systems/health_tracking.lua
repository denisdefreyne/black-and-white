local Signal = require('engine.vendor.hump.signal')
local Engine = require('engine')

local HealthTracking = Engine.System.newType()

local Components = require('components')

function HealthTracking.new(entities)
  local requiredComponentTypes = {
    Components.HealthTracking,
  }

  return Engine.System.new(HealthTracking, entities, requiredComponentTypes)
end

function HealthTracking:updateEntity(entity, dt)
  local healthTrackingComponent = entity:get(Components.HealthTracking)
  local imageComponent = entity:get(Engine.Components.Image)

  local trackedEntity = healthTrackingComponent.entity
  local trackedEntityHealth = trackedEntity:get(Components.Health)

  if trackedEntityHealth.cur >= 5 then
    imageComponent.path = 'assets/health-5.png'
  elseif trackedEntityHealth.cur >= 4 then
    imageComponent.path = 'assets/health-4.png'
  elseif trackedEntityHealth.cur >= 3 then
    imageComponent.path = 'assets/health-3.png'
  elseif trackedEntityHealth.cur >= 2 then
    imageComponent.path = 'assets/health-2.png'
  elseif trackedEntityHealth.cur >= 1 then
    imageComponent.path = 'assets/health-1.png'
  end
end

return HealthTracking
