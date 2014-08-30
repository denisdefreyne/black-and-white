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

function addHitAnimation(isBig, x, y, entities)
  local imagePath = 'assets/bullet.png'
  local config = {
    position               = { 0, 0 },
    offset                 = { 0, 0 },
    bufferSize             = isBig and 400 or 10,
    emissionRate           = 100000,
    emitterLifetime        = isBig and 0.3 or 0.1,
    particleLifetime       = { 0.2, 1.0 },
    colors                 = {
                               255, 0, 0, 255,
                               255, 0, 0,   0,
                             },
    sizes                  = { 0.1, 0.1 },
    sizeVariation          = 1,
    speed                  = { 0, 250 },
    direction              = 3 * math.pi / 2,
    spread                 = math.pi * 2,
    linearAcceleration     = { 0, 200, 0, 800 },
    rotation               = { 0, 0 },
    spin                   = { 0, 0, 0 },
    radialAcceleration     = 0,
    tangentialAcceleration = 0.0,
  }

  local self = Engine.Entity.new()

  self:add(Engine.Components.Description,    'Explosion')
  self:add(Engine.Components.Z,              1)
  self:add(Engine.Components.ParticleSystem, imagePath, config, true)
  self:add(Engine.Components.Position, x, y)
  self:add(Engine.Components.Timewarp     )

  entities:add(self)
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
      local x = 90
      local y = 60
      addHitAnimation(true, x, y, self.entities)
    end
    return
  end

  if position.x > love.window.getWidth() and velocity.x >= 0 then
    self.entities:remove(entity)
    if collisionGroup.name == 'enemy' then
      whiteHealth.cur = whiteHealth.cur - 1
      local x = love.window.getWidth() - 110
      local y = 60
      addHitAnimation(true, x, y, self.entities)
    end
    return
  end
end

return Offscreen
