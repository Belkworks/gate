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
      if Channel.running then
        return 
      end
      Channel.running = true
      while Channel.enabled and Channel.callback and #Channel.events > 0 do
        local Event = table.remove(Channel.events, 1)
        pcall(Channel.callback, unpack(Event))
      end
      Channel.running = false
    end,
    _transformCallback = function(self, Value)
      local _exp_0 = type(Value)
      if 'nil' == _exp_0 then
        return nil
      elseif 'function' == _exp_0 then
        return Value
      elseif 'table' == _exp_0 then
        if Value.emit then
          return function(...)
            return Value:emit(...)
          end
        else
          return error('gate: table must have an \'emit\' method!')
        end
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
    flush = function(self, Name)
      local Channel = self:_getChannel(Name)
      if Channel.enabled then
        return 
      end
      self:resume(Name)
      return self:pause(Name)
    end,
    clear = function(self, Name)
      local Channel = self:_getChannel(Name)
      Channel.events = { }
    end,
    handle = function(self, Name, Callback)
      local Channel = self:_getChannel(Name)
      Channel.callback = self:_transformCallback(Callback)
      if Callback and Channel.enabled then
        return self:_runChannel(Channel)
      end
    end,
    emit = function(self, Name, ...)
      local Channel = self:_getChannel(Name)
      table.insert(Channel.events, {
        ...
      })
      return self:_runChannel(Channel)
    end,
    Destroy = function(self)
      self.channels = { }
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
end
return Gate
