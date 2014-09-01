local Engine = require('engine')

local TitleSpace = require('spaces.title')
local Components = require('components')
local Gamestate = require('engine.vendor.hump.gamestate')

local Title = {}

local lw = love.window

local function createBackground()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, lw.getWidth() / 2, lw.getHeight() / 2)
  e:add(Engine.Components.Z, -100)
  e:add(Engine.Components.Image, 'assets/titlescreen.jpg')
  return e
end

local function newGameButtonClicked(entity)
  local MainState = require('gamestates.main')
  Gamestate.switch(MainState.new())
end

local function createNewGameButton()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, lw.getWidth() / 2, lw.getHeight() - 100)
  e:add(Engine.Components.Size,     400, 100)
  e:add(Engine.Components.Z, -90)
  e:add(Engine.Components.Renderer, 'button')
  e:add(Engine.Components.CursorTracking)
  e:add(Engine.Components.Button, 'New Game')
  e:add(Engine.Components.OnClick, newGameButtonClicked)
  return e
end

function Title.new()
  local entities = Engine.Types.EntitiesCollection:new()
  entities:add(createBackground())
  entities:add(createNewGameButton())
  local TitleSpace = TitleSpace.new(entities)

  return Engine.Gamestate.new({ TitleSpace })
end

return Title
