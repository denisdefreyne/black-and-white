local ProFi      = require('vendor.ProFi')
local Gamestate  = require('engine.vendor.hump.gamestate')
local TitleState  = require('gamestates.title')

function love.load()
  love.mouse.setGrabbed(true)
  love.graphics.setDefaultFilter('nearest')

  music = love.audio.newSource('assets/wayfinder - 20140830 - minijam - blackbird.mp3')
  music:play()

  -- ProFi:start()
  Gamestate.registerEvents()
  Gamestate.switch(TitleState.new())
end

function love.quit()
  -- ProFi:stop()
  -- ProFi:writeReport('profile.txt')
end
