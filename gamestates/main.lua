local Engine   = require('engine')

local ArenaSpace = require('spaces.arena')
local HUDSpace   = require('spaces.hud')
local Components = require('components')

local Main = {}

local xOffset = 80

local function createBackground()
  local e = Engine.Entity.new()
  e:add(Engine.Components.Position, love.window.getWidth() / 2, love.window.getHeight() / 2)
  e:add(Engine.Components.Z, -100)
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
  e:add(Components.Health, 5)
  e:add(Engine.Components.Rotation, math.pi)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Image, animationImagePaths[1])
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
  e:add(Components.Health, 5)
  e:add(Engine.Components.Z, 0)
  e:add(Engine.Components.Image, animationImagePaths[1])
  e:add(Components.Animation, animationImagePaths, 0.15)
  return e
end

local function createEnemySpawner()
  local e = Engine.Entity.new()
  e:add(Components.EnemySpawner)
  return e
end

local function createHealthBar(player, isBlack)
  local x = isBlack and 90 or love.window.getWidth() - 110
  local y = 60

  local e = Engine.Entity.new()
  e:add(Engine.Components.Image, 'assets/health-10.png')
  e:add(Engine.Components.Position, x, y)
  e:add(Engine.Components.Z, 100)
  e:add(Engine.Components.Scale, 0.8)
  e:add(Components.HealthTracking, player)
  return e
end

function Main.new()
  local blackPlayer = createBlackPlayer()
  local whitePlayer = createWhitePlayer()

  local arenaEntities = Engine.Types.EntitiesCollection.new()
  arenaEntities:add(createBackground())
  arenaEntities:add(blackPlayer)
  arenaEntities:add(whitePlayer)
  arenaEntities:add(createEnemySpawner())
  local arenaSpace = ArenaSpace.new(arenaEntities)

  local hudEntities = Engine.Types.EntitiesCollection.new()
  hudEntities:add(createHealthBar(blackPlayer, true))
  hudEntities:add(createHealthBar(whitePlayer, false))
  local hudSpace = HUDSpace.new(hudEntities)

  return Engine.Gamestate.new({ hudSpace, arenaSpace })
end

return Main
