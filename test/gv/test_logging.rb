require 'minitest_helper'
require 'gv/common/logging'

module GV
  module Common
    class TestLogging < Minitest::Test
      
      def test_methods
        %w(debug info warn error fatal).each do |met|
          public_send(met,"test")
        end
      end
      
    end
  end
end