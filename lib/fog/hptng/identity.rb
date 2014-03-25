require_relative './core'
require 'fog/hptng/identity/authenticator'



module Fog
  module Identity
    class HpTng < Fog::Service


      requires :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes :hp_auth_uri, :credentials, :hp_service_type, :hp_tenant_name
      recognizes :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes :hp_access_key
      secrets :hp_secret_key


      #model_path 'fog/hp_tng/models/identity

      class Mock

      end

      class Real



        def initialize(options={})
          customize_options(options)
          @osc_identity = Fog::Identity::V2::OpenStackCommon.new(options)
        end


        def customize_options(options)
          options.merge!(:openstack_username => options[:hp_access_key])
          options.merge!(:openstack_api_key => options[:hp_secret_key])
          options.merge!(:openstack_auth_url => options[:hp_auth_uri])
          options.merge!(:openstack_region => options[:hp_avl_zone ] )
          options.merge!(:openstack_tenant => options[:hp_tenant_name] )
          options.merge!(:openstack_use_upass_auth_style => (options[:hp_use_upass_auth_style]) || false)
          options.merge!(:openstack_endpoint_type => "publicURL")
        end

        def method_missing(method, *args)
          @osc_identity.send(method, *args)
        end

      end

#       module Fog
#   module Openstack
#     module Rackspace
#       class Identity < Fog::Service
#         US_ENDPOINT = 'https://identity.api.rackspacecloud.com/v2.0'
#         UK_ENDPOINT = 'https://lon.identity.api.rackspacecloud.com/v2.0'
#
#         requires :rackspace_username, :rackspace_api_key
#         recognizes :rackspace_auth_url, :rackspace_region
#
#         def initialize(options = {})
#           options[:authenticator] ||= RackspaceAuthenticator
#           @osc_identity = Fog::OpenStackCommon::Identity.new(options)
#         end
#
#         def method_missing(method, *args)
#           @osc_identity.send(method, *args)
#         end
#       end
#     end
#   end
# end

    end
  end
end
