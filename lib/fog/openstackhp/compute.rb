require 'fog/openstackhp/core'


module Fog
  module OpenStackHp
    class Compute


      def self.new(options)
        Fog::OpenStackCore::ServiceDiscovery.new(
          'openstackhp',
          'compute',
          options
        ).call
      end


    end
  end
end