local Engine = require('engine')

local Hit = {}

function Hit.new(isBig, x, y, entities)
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

  self:add(Engine.Components.Z,              1)
  self:add(Engine.Components.ParticleSystem, imagePath, config, true)
  self:add(Engine.Components.Position, x, y)
  self:add(Engine.Components.Timewarp     )

  return self
end

return Hit
