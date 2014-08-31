local Observable = {}

local Signal = require('engine.vendor.hump.signal')

local mt = {}

function Observable.wrap(wrappee, signal)
  return setmetatable({ wrappee = wrappee, signal = signal }, mt)
end

function mt:__index(key)
  return self.wrappee[key]
end

function mt:__newindex(key, value)
  self.wrappee[key] = value
  Signal.emit(self.signal, self.wrappee, key, value)
end

return Observable
