-- gate.moon
-- SFZILabs 2021

class Gate
    new: =>
        @channels = {} -- channel: { callback: fn, enabled: true, events: {event}
    
    _getChannel: (Name) =>
        assert Name, 'gate: channel must have a name!'

        if Existing = @channels[Name]
            return Existing

        NewChannel =
            callback: nil
            enabled: true
            events: {}

        @channels[Name] = NewChannel
        NewChannel

    _runChannel: (Channel) =>
        return if Channel.running
        Channel.running = true

        while Channel.enabled and Channel.callback and #Channel.events > 0
            Event = table.remove Channel.events, 1 -- { ... }
            pcall Channel.callback, unpack Event

        Channel.running = false

    _transformCallback: (Value) =>
        switch type Value
            when 'nil' then nil
            when 'function' then Value 
            when 'table'
                if Value.emit
                    (...) -> Value\emit ...
                else error 'gate: table must have an \'emit\' method!'

    pause: (Name) =>
        (@_getChannel Name).enabled = false

    resume: (Name) =>
        Channel = @_getChannel Name
        Channel.enabled = true

        if Channel.callback
            @_runChannel Channel

    flush: (Name) =>
    	Channel = @_getChannel Name
    	return if Channel.enabled
    	@resume Name
    	@pause Name

    clear: (Name) =>
        Channel = @_getChannel Name
        Channel.events = {}

    handle: (Name, Callback) =>
        Channel = @_getChannel Name
        Channel.callback = @_transformCallback Callback

        if Callback and Channel.enabled
            @_runChannel Channel

    emit: (Name, ...) =>
        Channel = @_getChannel Name
        table.insert Channel.events, { ... }
        @_runChannel Channel

    Destroy: =>
        @channels = {}

Gate
