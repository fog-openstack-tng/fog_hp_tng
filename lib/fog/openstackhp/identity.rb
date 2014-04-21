require 'fog/OpenStackHp/core'
require 'fog/openstackcore/identity'
require 'fog/openstackcore/common'

module Fog
  module OpenStackHp
    class Identity


      def self.new(options)
        Fog::OpenStackCore::ServiceDiscovery.new(
          'openstackhp',
          'identity',
          options
        ).call
      end


    end
  end
end
