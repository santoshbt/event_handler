The process uses handling blocks via procs.
Procs are chosen as we want blocks to be passed to method and stored in a variable for later usage like unsbuscribe and broadcast.
Also since variable number of arguments are being passed to evaluate the blocks, procs are much suitable.

Execute the event handler

- ruby event_handler.rb

Examples
--------

subscribed_events = EventHandler.subscribe {|x| x}
puts subscribed_events
puts subscribed_events.first.call(10)   

subscribed_events = EventHandler.subscribe {|x, y| x + 4 * 250 + y}
puts subscribed_events
puts subscribed_events[1].call(2,5)

remaining_subscribed_events = EventHandler.unsubscribe {|x| x}
puts remaining_subscribed_events

broadcast_handler = EventHandler.broadcast(1,2,3,4)
puts broadcast_handler

broadcast_handler = EventHandler.broadcast(150, 240)
puts broadcast_handler


Execute the spec by the command

- rspec event_handler_spec.rb

