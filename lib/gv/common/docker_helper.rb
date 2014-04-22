require 'gv/common/pipe_helper'
require 'json'
require 'timeout'

module GV
  module Common
    module DockerHelper
      
      include GV::Common::PipeHelper
      
      SPAWN_TIMEOUT = 30
      
      module_function
      
      def info container_id
        JSON.load(pipe("docker inspect #{container_id}")).first rescue nil
      end

      def ps name
        pipe("docker ps | grep #{name}")
      end
      
      def ps? name
        pipe("docker ps | grep #{name}") =~ /#{name}/
      end
      
      def container_id name 
        pipe "docker ps | grep #{name} | awk '{ print $1 }'"
      end
      
      def container_port name, ip, port
        pipe "docker port #{container_id(name)} #{port} | sed 's/#{ip}://'"
      end
      
      def pull_image_if_does_not_exists name
        pipe("docker pull #{name}", &Blocks.stream) unless pipe("docker images") =~ /#{name}/
      end
      
      def cleanup
        batch "Exit", "rm", false
      end

      def batch pattern, method, wait = false
        sh "docker ps -a | grep #{pattern} | awk '{ print $1 }' | xargs docker #{method}", {err: "/dev/null"}, wait
      end
      
      def sh cmd, options = {}, wait = true
        begin
          ::Timeout::timeout(SPAWN_TIMEOUT) {      
            debug "SH #{cmd}"
            pid = spawn cmd, options
            Process.public_send(wait ? :wait : :detach, pid)
          } 
        rescue ::Timeout::Error,::Timeout::TimeoutError,::Object::TimeoutError
          restart_docker!
          sh cmd, options, wait
        end
      end  
      
      def restart_docker! container_id = nil, sec = 2
        pid, status = Process.wait2(spawn("service docker restart"))
        unless status.success?
          fatal "docker service cannot restarted, terminating..." 
          raise container_id if container_id
        else
          sleep sec  
        end
      end
      
      
    end
  end
end