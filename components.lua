require('engine')

local Components = {}

Components.BlackPlayer = {
  order  = 1,
  name   = 'Black player',
  new    = function() return {} end,
  format = function(self) return 'Yes' end,
}

Components.WhitePlayer = {
  order  = 2,
  name   = 'White player',
  new    = function() return {} end,
  format = function(self) return 'Yes' end,
}

Components.Gun = {
  order  = 3,
  name   = 'Gun',
  new    = function() return { maxCooldown = 0.2, curCooldown = 0 } end,
  format = function(self) return 'Yes' end,
}

Components.EnemySpawner = {
  order  = 4,
  name   = 'Enemy spawner',
  new    = function() return { maxCooldown = 2.0, curCooldown = 0 } end,
  format = function(self) return 'Yes' end,
}

return Components
