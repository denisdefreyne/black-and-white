local Signal = require('engine.vendor.hump.signal')
local Engine = require('engine')

local EnemySpawner = Engine.System.newType()

local Components = require('components')
local Prefabs = require('prefabs')

function EnemySpawner.new(entities)
  local requiredComponentTypes = {
    Components.EnemySpawner,
  }

  return Engine.System.new(EnemySpawner, entities, requiredComponentTypes)
end

function EnemySpawner:updateEntity(entity, dt)
  local enemySpawnerComponent = entity:get(Components.EnemySpawner)

  enemySpawnerComponent.lifetime = enemySpawnerComponent.lifetime + dt
  enemySpawnerComponent.maxCooldown =  3.0 - math.log(1 + math.log(1 + enemySpawnerComponent.lifetime)) / 2

  if enemySpawnerComponent.curCooldown <= 0 then
    self.entities:add(Prefabs.createEnemy(true))
    self.entities:add(Prefabs.createEnemy(false))

    enemySpawnerComponent.curCooldown = enemySpawnerComponent.curCooldown + enemySpawnerComponent.maxCooldown
  end

  enemySpawnerComponent.curCooldown = enemySpawnerComponent.curCooldown - dt
end

return EnemySpawner
