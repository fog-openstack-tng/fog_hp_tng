require 'fog/hptng/core'
require 'fog/openstackcommon/identity'

require 'fog/openstackcommon/common'

module Fog
  module HpTng
    class Identity


      def self.new(options)
        Fog::OpenStackCommon::Identity.new(
          customize_options(options)
        )
      end

      def self.customize_options(options)
        opts = options.dup
        opts.merge!(:base_provider => Fog::HpTng)
        opts
      end


    end
  end
end
