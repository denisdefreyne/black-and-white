require('engine')

local Components = {}

Components.BlackPlayer = {
  new    = function() return {} end,
  format = function(self) return 'Yes' end,
}

Components.WhitePlayer = {
  new    = function() return {} end,
  format = function(self) return 'Yes' end,
}

Components.Gun = {
  new    = function() return { maxCooldown = 0.4, curCooldown = 0.1 } end,
  format = function(self) return 'Yes' end,
}

Components.EnemySpawner = {
  new    = function() return { maxCooldown = 3.0, curCooldown = 0, lifetime = 0 } end,
  format = function(self) return 'Yes' end,
}

Components.CollisionGroup = {
  new    = function(name) return { name = name } end,
  format = function(self) return '' .. name end,
}

Components.OriginatingEntity = {
  new    = function(entity) return { entity = entity } end,
  format = function(self) return '' end,
}

Components.Health = {
  new    = function(max) return { cur = max, max = max } end,
  format = function(self) return '' end,
}

Components.HealthTracking = {
  new    = function(entity) return { entity = entity } end,
  format = function(self) return '' end,
}

Components.EnemyBehavior = {
  new    = function() return { freq = (2 + math.random()) * 1.5, lifetime = math.random()*10 } end,
  format = function(self) return '' end,
}

return Components
