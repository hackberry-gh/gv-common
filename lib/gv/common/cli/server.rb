$stdout.sync = true
$stderr.sync = true

module GV
  module Common
    module CLI
      module Server
        
        module_function
        
        def gen lib, services
          
          require "gv/#{lib}"
          require "commander/import"
          require "active_support/inflector"

          program :name, "Green Valley #{lib.capitalize}"
          program :version, '0.0.1'
          program :description, 'Green Valley #{lib.capitalize} CLI'

          command :provide do |c|
            c.syntax = "gv-#{lib} provide SERVICE"
            c.description = 'Provides a service'
            c.action do |args, options|
              service = args.shift
              require service
              service_class = service.classify.gsub("Gv","GV").constantize
              service_class.provide
            end
          end

          command :'service' do |c|
            c.syntax = "gv-#{lib} service SERVICE METHOD <ARGS>"
            c.description = 'Runs method on remote service'
            c.action do |args, options|
    
              service = args.shift
              method = args.shift    
              require service
              service_class = service.classify.gsub("Gv","GV").constantize
        
              DRb.start_service
              service = service_class.service
              result = service.public_send(method,*args)
              puts result
              DRb.stop_service
    
            end
          end

          command :run do |c|
            c.syntax = "gv-#{lib} run"
            c.description = 'Runs everything'
            c.action do |args, options|
    
              pids = []
              services.each do |service|
                pids << spawn("gv-#{lib} provide #{service}")
                Process.detach(pids.last)
                sleep 2
              end
    
              at_exit { pids.each{|pid| Process.kill "TERM", pid} }
    
              loop do; end
    
            end
          end
          
        end
        
      end
    end
  end
end