require 'sticks/pipe'

module GV
  module Common
    module PipeHelper
      
      include Sticks::Pipe
      
      module_function
      
      def indicate string
        say %(-----> #{string}), &@block
      end

      def say string
        pipe %(echo '\e[1G#{string}'), &@block      
      end 

    end
  end
end