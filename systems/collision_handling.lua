local Engine = require('engine')
local Signal = require('engine.vendor.hump.signal')
local Components = require('components')

local CollisionHandler = {}
CollisionHandler.__index = CollisionHandler

function CollisionHandler.new(entities)
  local t = {
    entities   = entities,
    collisions = {},
    callbacks  = {},
  }

  local collisionDetected = function(tbl)
    table.insert(t.collisions, tbl)
  end
  t.callbacks.collisionDetected = collisionDetected
  -- TODO: Do not hardcode this constant
  Signal.register('engine:systems:collision:detected', collisionDetected)

  return setmetatable(t, CollisionHandler)
end

function CollisionHandler:leave()
  Signal.remove('engine:systems:collision:detected', self.callbacks.collisionDetected)
end

function CollisionHandler:update(dt)
  for _, pair in ipairs(self.collisions) do
    self:pairDetected(pair.a, pair.b)
  end
  self.collisions = {}
end

function CollisionHandler:pairDetected(a, b)
  if self:pairInteracts(a, b) then
    self:singleDetected(a, b)
  end
end

function CollisionHandler:pairInteracts(a, b)
  local aCollisionGroup = a:get(Components.CollisionGroup)
  local bCollisionGroup = b:get(Components.CollisionGroup)

  if not aCollisionGroup then return false end
  if not bCollisionGroup then return false end

  local aOriginatingEntity = a:get(Components.OriginatingEntity)
  local bOriginatingEntity = b:get(Components.OriginatingEntity)

  if aOriginatingEntity and aOriginatingEntity.entity == b then
    return false
  elseif bOriginatingEntity and bOriginatingEntity.entity == a then
    return false
  end

  return aCollisionGroup.name == 'bullet' or bCollisionGroup.name == 'bullet'
end

function CollisionHandler:singleDetected(entity, otherEntity)
  self.entities:remove(entity)
  if true then return end

  -- TODO: Implement

  local health        = entity:get(Components.Health)
  local position      = entity:get(Engine.Components.Position)

  health.cur = health.cur - 1
  if health.cur <= 0 then
    self.entities:remove(entity)
  end
end

return CollisionHandler
