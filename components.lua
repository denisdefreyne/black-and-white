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

return Components
