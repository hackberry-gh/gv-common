require 'sticks/pipe'
require 'open3'

module GV
  module Common
    module HostHelper
      
      include Sticks::Pipe      
      
      ##
      # Several configuration helpers
      #
      
      def external_ip interface = "eth0"
        @external_ip ||= pipe("/sbin/ifconfig #{interface} | grep 'inet addr' | awk -F: '{print $2}' | awk '{print $1}'")
      end

      def hostname
        @hostname ||= pipe("hostname -f")
      end

      def port
        @port ||= ENV['PORT']
      end
      
    end
  end
end