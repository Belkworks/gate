
# Gate
*An event handler in MoonScript.*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
Gate = NEON:github('belkworks', 'gate')
```

## API

### Creating Gates

To create a gate, call `Gate`.  
No parameters are available at this time.
```lua
G = Gate()
```

### Handling Events

Use the **handle** method to attach a listener to a channel.
`gate:handle(channel, handler) -> nil`  
`handler` can be a `function` or another **Gate** instance.
```lua
G:handle('test', function(...)
    -- handle an event
end)

-- alternatively,
G2 = Gate()
G2:handle('abc', print)

G:handle('stuff', G2) -- pass 'stuff' events to G2
```

### Running Events

To run an event, use the **emit** method.  
`gate:emit(channel, ...) -> nil`
```lua
G:emit('test', 123) -- runs our defined 'test' runner
G:emit('stuff', 'abc', 456) -- prints 456
```

### Controlling Channels

To pause a channel, use the **pause** method.  
`gate:pause(channel) -> nil`
```lua
G:pause('stuff') -- 'stuff' events will be queued instead of running
```

To resume a paused channel, use the **resume** method.
`gate:resume(channel) -> nil`
```lua
G:emit('stuff', 'abc', 789) -- does nothing
G:resume('stuff') -- runs queued 'stuff' events, printing 789
```

To clear pending events in a channel, use the **clear** method.  
`gate:clear(channel) -> nil`
```lua
G:clear('stuff') -- deletes pending 'stuff' events
```
