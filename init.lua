local Gate
do
  local _class_0
  local _base_0 = {
    _getChannel = function(self, Name)
      assert(Name, 'gate: channel must have a name!')
      do
        local Existing = self.channels[Name]
        if Existing then
          return Existing
        end
      end
      local NewChannel = {
        callback = nil,
        enabled = true,
        events = { }
      }
      self.channels[Name] = NewChannel
      return NewChannel
    end,
    _runChannel = function(self, Channel)
      if not (Channel.callback) then
        return 
      end
      while Channel.enabled and Channel.callback and #Channel.events > 0 do
        local Event = table.remove(Channel.events, 1)
        Channel.callback(unpack(Event))
      end
    end,
    pause = function(self, Name)
      (self:_getChannel(Name)).enabled = false
    end,
    resume = function(self, Name)
      local Channel = self:_getChannel(Name)
      Channel.enabled = true
      if Channel.callback then
        return self:_runChannel(Channel)
      end
    end,
    clear = function(self, Name)
      local Channel = self:_getChannel(Name)
      Channel.events = { }
    end,
    handle = function(self, Name, Callback)
      local Channel = self:_getChannel(Name)
      Channel.callback = Callback
      if Callback and Channel.enabled then
        return self:_runChannel(Channel)
      end
    end,
    emit = function(self, Name, ...)
      local Channel = self:_getChannel(Name)
      if Channel.callback and Channel.enabled then
        return Channel.callback(...)
      else
        return table.insert(Channel.events, {
          ...
        })
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.channels = { }
    end,
    __base = _base_0,
    __name = "Gate"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Gate = _class_0
  return _class_0
end
