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

  local aIsPlayer = a:get(Components.BlackPlayer) or a:get(Components.WhitePlayer)
  local bIsPlayer = b:get(Components.BlackPlayer) or b:get(Components.WhitePlayer)

  local aIsBullet = aCollisionGroup.name == 'bullet'
  local bIsBullet = bCollisionGroup.name == 'bullet'

  if aIsPlayer or bIsPlayer then
    return false
  else
    return (aIsBullet or bIsBullet) and not (aIsBullet and bIsBullet)
  end
end

function CollisionHandler:singleDetected(entity, otherEntity)
  local health = entity:get(Components.Health)
  if not health then
    self.entities:remove(entity)
    return
  end

  health.cur = health.cur - 1
  if health.cur < 1 then
    if entity:get(Components.BlackPlayer) or entity:get(Components.WhitePlayer) then
    else
      self.entities:remove(entity)
    end
  end
end

return CollisionHandler
