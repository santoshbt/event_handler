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
                "Arguments required"
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