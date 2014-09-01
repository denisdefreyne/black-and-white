local Engine = require('engine')

local Button = {}

local lg = love.graphics

local buttonFont = lg.newFont(24)

function Button.draw(entity)
  local position = entity:get(Engine.Components.Position)
  if not position then return end

  local size = Engine.sizeForEntity(entity)
  if not size then return end

  local button = entity:get(Engine.Components.Button)
  if not button then return end

  local cursorTracking = entity:get(Engine.Components.CursorTracking)
  if not cursorTracking then return end

  -- Background
  if cursorTracking.isDown then
    lg.setColor(255, 255, 255, 255)
  elseif cursorTracking.isHovering then
    lg.setColor(255, 0, 0, 255)
  else
    lg.setColor(0, 0, 0, 255)
  end
  lg.translate(-size.width/2, -size.height/2)
  lg.rectangle('fill', 0, 0, size.width, size.height)

  -- Label
  if cursorTracking.isDown then
    lg.setColor(0, 0, 0, 255)
  elseif cursorTracking.isHovering then
    lg.setColor(255, 255, 255, 255)
  else
    lg.setColor(255, 0, 0, 255)
  end
  local y = size.height / 2 - buttonFont:getHeight() / 2
  lg.setFont(buttonFont)
  lg.printf(button.label, 0, y, size.width, 'center')
end

return Button
