local Engine = require('engine')

local Health = Engine.System.newType()

local Components = require('components')

function Health.new(entities)
  local requiredComponentTypes = {
    Components.Health,
  }

  return Engine.System.new(Health, entities, requiredComponentTypes)
end

function Health:updateEntity(entity, dt)
  local healthComponent = entity:get(Components.Health)

  if healthComponent.cur < 1 then
    self.entities:remove(entity)

    local onDeathComponent = entity:get(Components.OnDeath)
    if onDeathComponent then
      onDeathComponent.fn(entity)
    end
  end
end

return Health
