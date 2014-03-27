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
          @options = options.dup
          @osc_identity = Fog::Identity::V2::OpenStackCommon.new(
            customize_options(@options)
          )
        end


        def customize_options(options)
          opts = options.dup
          opts.merge!(:openstack_username => opts.delete(:hp_access_key))
          opts.merge!(:openstack_api_key => opts.delete(:hp_secret_key))
          opts.merge!(:openstack_auth_url => opts.delete(:hp_auth_uri))
          opts.merge!(:openstack_region => opts.delete(:hp_avl_zone ) )
          opts.merge!(:openstack_tenant_name => opts.delete(:hp_tenant_name) )
          opts.merge!(:openstack_tenant_id => opts.delete(:hp_tenant_id))
          opts.merge!(:openstack_use_upass_auth_style => opts.delete(:hp_use_upass_auth_style))
          opts.merge!(:openstack_endpoint_type => "publicURL")
          opts.merge!(:authenticator => Fog::HpTng::Authentication::Adapters::AuthenticatorV2.new)
          opts
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
