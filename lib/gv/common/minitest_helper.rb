require 'gv/bedrock/server'

class Minitest::Test
  
  def provide service_class
    pid = fork {
      service_class.provide
    }
    Process.detach pid
    sleep 2    
    pid
  end

  def kll pid
    Process.kill "TERM", pid rescue nil
  end
  
  def start_server
    @serverpid = fork { 
      server = GV::Bedrock::Server.new
      server.start 
    }
    sleep 2
  end
  
  def stop_server
    kll @serverpid
  end
  
end