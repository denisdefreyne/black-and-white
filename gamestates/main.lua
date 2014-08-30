local Engine   = require('engine')

local ArenaSpace = require('spaces.arena')
local Components = require('components')

local Main = {}

local xOffset = 50

local function createBackground()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() / 2, love.window.getHeight() / 2)
  e:add(Engine.Components.Z, -1)
  e:add(Engine.Components.Image, 'assets/background2.png')
  return e
end

local function createBlackPlayer()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, xOffset, love.window.getHeight() / 2)
  e:add(Components.BlackPlayer)
  e:add(Components.Gun)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Image, 'assets/player-black.png')
  return e
end

local function createWhitePlayer()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() - xOffset, love.window.getHeight() / 2)
  e:add(Engine.Components.Rotation, math.pi)
  e:add(Components.WhitePlayer)
  e:add(Components.Gun)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Image, 'assets/player-white.png')
  return e
end

local function createEntities()
  local entities = Engine.Types.EntitiesCollection.new()

  entities:add(createBackground())
  entities:add(createBlackPlayer())
  entities:add(createWhitePlayer())

  return entities
end

function Main.new()
  local entities = createEntities()
  local arenaSpace = ArenaSpace.new(entities)

  return Engine.Gamestate.new({ arenaSpace })
end

return Main
