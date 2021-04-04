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
        while Channel.enabled and Channel.callback and #Channel.events > 0
            Event = table.remove Channel.events, 1 -- { ... }
            Channel.callback unpack Event

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
        if Channel.callback and Channel.enabled
            Channel.callback ...
        else table.insert Channel.events, { ... }

class Gate.Async extends Gate
    _runChannel: (Channel) =>
        return if Channel.running
        if Channel.enabled and Channel.callback and #Channel.events > 0
            Event = table.remove Channel.events, 1 -- { ... }

            done = ->
                Channel.running = false
                @_runChannel Channel

            Channel.running = true
            Channel.callback done, unpack Event

    emit: (Name, ...) =>
        Channel = @_getChannel Name
        table.insert Channel.events, { ... }
        @_runChannel Channel

Gate
