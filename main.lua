local ProFi      = require('vendor.ProFi')
local Gamestate  = require('engine.vendor.hump.gamestate')
local MainState  = require('gamestates.main')

function love.load()
  love.mouse.setGrabbed(true)
  love.graphics.setDefaultFilter('nearest')

  -- ProFi:start()
  Gamestate.registerEvents()
  Gamestate.switch(MainState.new())
end

function love.quit()
  -- ProFi:stop()
  -- ProFi:writeReport('profile.txt')
end
