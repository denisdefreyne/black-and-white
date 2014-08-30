local Engine   = require('engine')

local ArenaSpace = require('spaces.arena')
local Components = require('components')

local Main = {}

local xOffset = 80

local function createBackground()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() / 2, love.window.getHeight() / 2)
  e:add(Engine.Components.Z, -1)
  e:add(Engine.Components.Image, 'assets/background2.png')
  return e
end

local function createBlackPlayer()
  local animationImagePaths = {
    'assets/real/black_bird_idleanim_1.png',
    'assets/real/black_bird_idleanim_2.png',
    'assets/real/black_bird_idleanim_3.png',
    'assets/real/black_bird_idleanim_4.png',
    'assets/real/black_bird_idleanim_5.png',
  }

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, xOffset, love.window.getHeight() / 2)
  e:add(Components.BlackPlayer)
  e:add(Components.Gun)
  e:add(Components.CollisionGroup, 'black')
  e:add(Engine.Components.Rotation, math.pi)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Image, 'assets/player-black.png')
  e:add(Components.Animation, animationImagePaths, 0.15)
  return e
end

local function createWhitePlayer()
  local animationImagePaths = {
    'assets/real/white_bird_idleanim_1.png',
    'assets/real/white_bird_idleanim_2.png',
    'assets/real/white_bird_idleanim_3.png',
    'assets/real/white_bird_idleanim_4.png',
    'assets/real/white_bird_idleanim_5.png',
  }

  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() - xOffset, love.window.getHeight() / 2)
  e:add(Components.WhitePlayer)
  e:add(Components.Gun)
  e:add(Components.CollisionGroup, 'white')
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Image, 'assets/player-white.png')
  e:add(Components.Animation, animationImagePaths, 0.15)
  return e
end

local function createEnemySpawner()
  local e = Engine.Entity.new()
  e:add(Components.EnemySpawner)
  return e
end

local function createEntities()
  local entities = Engine.Types.EntitiesCollection.new()

  entities:add(createBackground())
  entities:add(createBlackPlayer())
  entities:add(createWhitePlayer())
  entities:add(createEnemySpawner())

  return entities
end

function Main.new()
  local entities = createEntities()
  local arenaSpace = ArenaSpace.new(entities)

  return Engine.Gamestate.new({ arenaSpace })
end

return Main
