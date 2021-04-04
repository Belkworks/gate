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
		return unless Channel.callback
		while Channel.enabled and Channel.callback and #Channel.events > 0
			Event = table.remove Channel.events, 1 -- { ... }
			Channel.callback unpack Event

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
		Channel.callback = Callback

		if Callback and Channel.enabled
			@_runChannel Channel

	emit: (Name, ...) =>
		Channel = @_getChannel Name
		if Channel.callback and Channel.enabled
			Channel.callback ...
		else table.insert Channel.events, { ... }
