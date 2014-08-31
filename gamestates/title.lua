local Engine = require('engine')

local TitleSpace = require('spaces.game_over')
local Components    = require('components')

local Title = {}

local function createBackground()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() / 2, love.window.getHeight() / 2)
  e:add(Engine.Components.Z, -100)
  e:add(Engine.Components.Image, 'assets/titlescreen.jpg')
  return e
end

function Title.new()
  local entities = Engine.Types.EntitiesCollection:new()
  entities:add(createBackground())
  local TitleSpace = TitleSpace.new(entities)

  return Engine.Gamestate.new({ TitleSpace })
end

return Title
