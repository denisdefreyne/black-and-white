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
  new    = function() return { maxCooldown = 0.4, curCooldown = 0.1 } end,
  format = function(self) return 'Yes' end,
}

Components.EnemySpawner = {
  order  = 4,
  name   = 'Enemy spawner',
  new    = function() return { maxCooldown = 3.0, curCooldown = 0, lifetime = 0 } end,
  format = function(self) return 'Yes' end,
}

Components.CollisionGroup = {
  order  = 5,
  name   = 'Collision group',
  new    = function(name) return { name = name } end,
  format = function(self) return '' .. name end,
}

Components.OriginatingEntity = {
  order  = 6,
  name   = 'Originating entity',
  new    = function(entity) return { entity = entity } end,
  format = function(self) return '' end,
}

Components.Health = {
  order  = 8,
  name   = 'Health',
  new    = function(max) return { cur = max, max = max } end,
  format = function(self) return '' end,
}

Components.HealthTracking = {
  order  = 9,
  name   = 'Health tracking',
  new    = function(entity) return { entity = entity } end,
  format = function(self) return '' end,
}

Components.EnemyBehavior = {
  order  = 10,
  name   = 'Enemy behavior',
  new    = function() return { freq = (2 + math.random()) * 1.5, lifetime = math.random()*10 } end,
  format = function(self) return '' end,
}

return Components
