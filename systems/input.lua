local Engine = require('engine')
local Debugger = require('debugger')

local Gamestate = require('engine.vendor.hump.gamestate')

local Components = require('components')

local Input = {}
Input.__index = Input

function Input.new(entities)
  return setmetatable({ entities = entities }, Input)
end

local function shoot(entities)
end

function Input:update(dt)
  local whitePlayer = self.entities:firstWithComponent(Components.WhitePlayer)
  local blackPlayer = self.entities:firstWithComponent(Components.BlackPlayer)

  local whitePos = whitePlayer:get(Engine.Components.Position)
  local blackPos = blackPlayer:get(Engine.Components.Position)

  local speed = 600*dt

  local lk = love.keyboard

  if lk.isDown("up") then
    whitePos.y = whitePos.y + speed
    blackPos.y = blackPos.y - speed
  end

  if lk.isDown("down") then
    whitePos.y = whitePos.y - speed
    blackPos.y = blackPos.y + speed
  end

  if lk.isDown("space") then
    shoot(entities)
  end
end

return Input
