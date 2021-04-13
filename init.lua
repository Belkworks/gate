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
      while Channel.enabled and Channel.callback and #Channel.events > 0 do
        local Event = table.remove(Channel.events, 1)
        Channel.callback(unpack(Event))
      end
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
end
do
  local _class_0
  local _parent_0 = Gate
  local _base_0 = {
    _runChannel = function(self, Channel)
      if Channel.running then
        return 
      end
      if Channel.enabled and Channel.callback and #Channel.events > 0 then
        local Event = table.remove(Channel.events, 1)
        local done
        done = function()
          Channel.running = false
          return self:_runChannel(Channel)
        end
        Channel.running = true
        return Channel.callback(done, unpack(Event))
      end
    end,
    emit = function(self, Name, ...)
      local Channel = self:_getChannel(Name)
      table.insert(Channel.events, {
        ...
      })
      return self:_runChannel(Channel)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Async",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Gate.Async = _class_0
end
return Gate
