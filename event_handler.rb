require "rspec/autorun"

class EventHandler
    class << self
        @@handlers = []
        def subscribe(&block) 
            return "No block given" unless block_given?
            handler = Proc.new(&block)
            unless check_if_handler_exists(handler, @@handlers)
                @@handlers << handler
            else
                "Sorry, handler already exists."
            end
        end

        def unsubscribe(&block)
            return "No block given" unless block_given?
            remove_handler = Proc.new(&block)
             
            @@handlers.delete_if {|handler|
                run_proc(handler) == run_proc(remove_handler)
            }

            @@handlers
        end

        def broadcast(*values)
            if values.size > 0
                @@handlers.collect{|handler|
                    run_broadcast_proc(handler, values)
                }
            else
                "arguments required"
            end
        end

        private
        def check_if_handler_exists(handler, handlers)
            handlers.each do |existing_handler|
                if run_proc(existing_handler) == run_proc(handler)
                    return true
                end
            end

            return false
        end

        def run_proc(handler)
            begin
                handler.call(5)
            rescue => exception
                "invalid event"
            end
        end

        def run_broadcast_proc(handler, values)
            begin
                handler.call(values)
            rescue => exception
                "invalid broadcast event"
            end
        end
    end
end


describe EventHandler, ".subscribe" do
    it "it returns single stored event handler in an array" do
        subscribed_events = EventHandler.subscribe {|x| x}
        expect(subscribed_events.size).to eq(1) 
    end

    it "it returns multiple event handlers in an array" do
        new_subscribed_events = EventHandler.subscribe {|x, y| x + 4 * 250 + y}
        expect(new_subscribed_events.size).to eq(2) 
    end

    it "it returns handler already exits" do
        subscribed_events = EventHandler.subscribe {|x| x}
        expect(subscribed_events).to eq("Sorry, handler already exists.")
    end

    it "returns No block given" do
        subscribed_event = EventHandler.subscribe
        expect(subscribed_event).to eq("No block given")
    end
end

describe EventHandler, ".unsubscribe" do
    it "it removes the matching block from the stored handlers" do
        subscribed_events = EventHandler.unsubscribe {|x| x}
        expect(subscribed_events.size).to eq(1) 
    end

    it "returns No block given" do
        subscribed_events = EventHandler.unsubscribe
        expect(subscribed_events).to eq("No block given")
    end
end

describe EventHandler, ".broadcast" do
    it "it calls all the existing event handlers with arbitrary number of arguments (1,2,3,4)" do
        broadcast_handler_01 = EventHandler.broadcast(1,2,3,4)
        expect(broadcast_handler_01).to eq([1003]) 
    end

    it "it calls all the existing event handlers with arbitrary number of arguments (3, 8)" do
        broadcast_handler_02 = EventHandler.broadcast(150, 240)
        expect(broadcast_handler_02).to eq([1390])
    end

    it "it calls all the existing event handlers with no arguments ()" do
        broadcast_handler_03 = EventHandler.broadcast()
        expect(broadcast_handler_03).to eq("arguments required")
    end
end