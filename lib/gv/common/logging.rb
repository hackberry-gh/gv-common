require 'gv/common/core_ext/logger'

module GV
  module Common
    module Logging

      module_function
    
      def logger
        $logger ||= logger = Logger.new($stderr)
      end
    
      %w(debug info warn error fatal).each do |met|
        define_method(met){ |msg| logger.public_send(met,msg) }
      end
    
    end
  end
end

Object.send :include, GV::Common::Logging