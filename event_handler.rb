require "rspec/autorun"

class EventHandler
    class << self
        @@handlers = []
        def subscribe(&block) 
            return "No block given" unless block_given?
            handler = Proc.new(&block)
            @@handlers << handler
        end

        def unsubscribe(&block)
            rem_handler = Proc.new(&block)
             
            @@handlers.delete_if {|handler|
                run_proc(handler) == run_proc(rem_handler)
            }

            @@handlers
        end

        def broadcast(*values)
            @@handlers.collect{|handler|
                run_broadcast_proc(handler, values)
            }
        end

        private
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

    it "it returns single stored event handler in an array" do
        new_subscribed_events = EventHandler.subscribe {|x, y| x + 4 * 250 + y}
        expect(new_subscribed_events.size).to eq(2) 
    end
end

describe EventHandler, ".unsubscribe" do
    it "it removes the matching block from the stored handlers" do
        subscribed_events = EventHandler.unsubscribe {|x| x}
        expect(subscribed_events.size).to eq(1) 
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
end