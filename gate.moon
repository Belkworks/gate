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

	pause: (Name) =>
		(@_getChannel Name).enabled = false

	resume: (Name) =>
		Channel = @_getChannel Name
		Channel.enabled = true
		-- TODO: run channel

	clear: (Name) =>
		Channel = @_getChannel Name
		Channel.events = {}
