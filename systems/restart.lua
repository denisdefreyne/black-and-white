local Engine = require('engine')
local Gamestate = require('engine.vendor.hump.gamestate')

local Restart = Engine.System.newType()

function Restart.new(entities)
  local requiredComponentTypes = {}

  return Engine.System.new(Restart, entities, requiredComponentTypes)
end

function Restart:keypressed(key, isrepeat)
  if key == ' ' then
    local MainState = require('gamestates.main')
    Gamestate.switch(MainState.new())
  end
end

return Restart
