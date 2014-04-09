require_relative './core'
require 'fog/openstackcommon/identity'

require 'fog/openstackcommon/common'

module Fog
  module HpTng
    class Identity



        def initialize(options={})
          @options = options.dup
          @osc_identity = Fog::OpenStackCommon::Identity.new(
            customize_options(@options)
          )

        end

        def customize_options(options)
          opts = options.dup
          opts.merge!(:openstack_username => opts.delete(:hp_access_key))
          opts.merge!(:openstack_api_key => opts.delete(:hp_secret_key))
          opts.merge!(:openstack_auth_url => opts.delete(:hp_auth_uri))
          opts.merge!(:openstack_region => opts.delete(:hp_avl_zone ) )
          opts.merge!(:openstack_tenant => opts.delete(:hp_tenant_name) )
          #opts.merge!(:openstack_tenant_id => opts.delete(:hp_tenant_id))
          #opts.merge!(:openstack_use_upass_auth_style => opts.delete(:hp_use_upass_auth_style))
          opts.merge!(:base_provider => Fog::HpTng)
          opts
        end

        #this doesnt accomplish anything anymore because you end up delegating
        #to an instance of the OSC Identity Proxy
        #def method_missing(method, *args)
        #  @osc_identity.send(method, *args)
        #end



    end
  end
end
