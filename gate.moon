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
			enabled: false
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
