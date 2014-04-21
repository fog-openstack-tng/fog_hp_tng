require 'fog/hptng/core'
require 'fog/openstackcore/identity'
require 'fog/openstackcore/common'

module Fog
  module HpTng
    class Identity


      def self.new(options)
        Fog::OpenStackCore::ServiceDiscovery.new(
          'openstackcore',
          'identity',
          options.merge(:base_provider => Fog::HpTng)
        ).call
      end


    end
  end
end
