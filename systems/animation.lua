local Engine = require('engine')
local Components = require('components')

local Animation = Engine.System.newType()

function Animation.new(entities)
  local requiredComponentTypes = {
    Components.Animation,
    Engine.Components.Image,
  }

  return Engine.System.new(Animation, entities, requiredComponentTypes)
end

function Animation:updateEntity(entity, dt)
  local animation = entity:get(Components.Animation)
  local image     = entity:get(Engine.Components.Image)

  animation.curDelay = animation.curDelay + dt
  if animation.curDelay > animation.delay then
    animation.curDelay = animation.curDelay - animation.delay

    animation.curFrame = animation.curFrame + 1
    if animation.curFrame > #animation.imagePaths then
      animation.curFrame = 1
    end
    image.path = animation.imagePaths[animation.curFrame]
  end
end

return Animation
