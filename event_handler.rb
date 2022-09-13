class EventHandler
    class << self
        @@handlers = []
        ### subscribe method will take a block input.
        ### It stores in handlers class variable, if that block does not already exist

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
            ### Unsubscribe method will delete the given block
            ### It will evaluate the each existing blocks against the given lock
            ### removes the matching one from the array.

            return "No block given" unless block_given?
            remove_handler = Proc.new(&block)
             
            @@handlers.delete_if {|handler|
                run_proc(handler) == run_proc(remove_handler)
            }

            @@handlers
        end

        def broadcast(*values)
            ### It takes the arbitrary number of arguments and calls all the existing blocks stored.

            if values.size > 0
                @@handlers.collect{ |handler|
                    run_broadcast_proc(handler, values)
                }
            else
                "Arguments required"
            end
        end

        private

        def check_if_handler_exists(handler, handlers)
            handlers.each do |existing_handler|
                if run_proc(existing_handler) != "Invalid event" && 
                    run_proc(handler) != "Invalid event" &&
                    run_proc(existing_handler) == run_proc(handler)
                    return true
                end
            end

            return false
        end

        def run_proc(handler)
            #### supply an initial argument Ex: 5, 4, 2 for comparison purpose.
            #### We may not be able to compare blocks / procs directly without the evaluating the block.
            #### This will be supplied as an argument to the block
            begin
                handler.call(5, 4, 2)
            rescue => exception
                "Invalid event"
            end
        end

        def run_broadcast_proc(handler, values)
            begin
                handler.call(values)
            rescue => exception
                "Invalid broadcast event"
            end
        end
    end
end
