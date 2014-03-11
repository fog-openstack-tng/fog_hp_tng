require 'fog/core'

require 'fog/openstackcommon'
require 'fog/hptng/identity/adapters/authenticator_v1'
require 'fog/hptng/identity/adapters/authenticator_v2'



module Fog
  module HpTng

    module Authenticator
      extend Fog::OpenStackCommon::Authenticator

      def self.adapters
        Fog::HpTng::Authentication::Adapters
      end

    end # Authenticator
  end # OpenStack
end # Fog
