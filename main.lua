package.path = package.path .. ';vendor/d-tech/?.lua;vendor/d-tech/?/init.lua'

local Gamestate = require('engine.vendor.hump.gamestate')
local TitleState = require('gamestates.title')

require('renderers')

function love.load()
  -- love.mouse.setGrabbed(true)
  love.graphics.setDefaultFilter('nearest')

  local music = love.audio.newSource('assets/wayfinder - 20140830 - minijam - blackbird.mp3')
  -- music:play()

  Gamestate.registerEvents()
  Gamestate.switch(TitleState.new())
end
