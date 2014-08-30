local Signal = require('engine.vendor.hump.signal')
local Engine = require('engine')
local Gamestate  = require('engine.vendor.hump.gamestate')

local GameOver = Engine.System.newType()

local Components = require('components')

function GameOver.new(entities)
  local requiredComponentTypes = {
    Components.Health,
  }

  return Engine.System.new(GameOver, entities, requiredComponentTypes)
end

function GameOver:updateEntity(entity, dt)
  local healthComponent = entity:get(Components.Health)

  if healthComponent.cur < 1 then
    local GameOverState  = require('gamestates.game_over')
    Gamestate.switch(GameOverState.new())
  end
end

return GameOver
