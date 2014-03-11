require_relative './core'
require 'fog/hptng/identity'
require 'fog/hptng/identity/authenticator'



module Fog
  module Identity
    class HpTng < OpenStackCommon


      requires :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes :hp_auth_uri, :credentials, :hp_service_type
      recognizes :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes :hp_access_key
      secrets :hp_secret_key

      recognizes :openstack_username,:openstack_api_key, :openstack_auth_url

      #model_path 'fog/hp_tng/models/identity

      class Mock

      end

      class Real < OpenStackCommon::Real


        def customize_options(options)
          options.merge!(:openstack_username => options[:hp_access_key])
          options.merge!(:openstack_api_key => options[:hp_secret_key])
          options.merge!(:openstack_auth_url => options[:hp_auth_uri])
          options.merge!(:openstack_region => options[:hp_avl_zone ] )
          options.merge!(:openstack_tenant => options[:hp_tenant_id ] )
          options.merge!(:openstack_use_upass_auth_style => (options[:hp_use_upass_auth_style]) || false)
        end

        def authenticator
         Fog::HpTng::Authenticator
        end


      end

    end
  end
end
