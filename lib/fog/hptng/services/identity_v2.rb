require 'fog/hptng/request_common'
require 'fog/openstackcommon/service_catalog'
require 'fog/openstackcommon/services/identity_v2'

module Fog
  module HpTng
    class IdentityV2 < Fog::OpenStackCommon::IdentityV2

      requires :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes :hp_auth_uri, :credentials, :hp_service_type, :hp_tenant_name
      recognizes :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes :hp_access_key
      secrets :hp_secret_key

      DEFAULT_AUTH_URI = "https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens"

      request_path 'fog/hptng/requests/identity/v2'

      ## Token Operations
      request :create_token
      request :validate_token

      # minimal requirement
      class Mock
      end


      class Real < Fog::OpenStackCommon::IdentityV2::Real

        def initialize(options={})
           @hp_options = options.dup
           super(customize_options(options))
        end

        private

        def customize_options(options)
          opts = options.dup
          opts.merge!(:openstack_username => opts.delete(:hp_access_key))
          opts.merge!(:openstack_api_key => opts.delete(:hp_secret_key))
          opts.merge!(:openstack_auth_url => opts.delete(:hp_auth_uri) || DEFAULT_AUTH_URI)
          opts.merge!(:openstack_region => opts.delete(:hp_avl_zone))
          opts.merge!(:openstack_tenant => opts.delete(:hp_tenant_name))
          opts
        end

        def authenticate
          return auth_with_credentials_and_tenant
        end

        def auth_with_credentials_and_tenant


          data = create_token(@hp_options[:hp_access_key],
                              @hp_options[:hp_secret_key],
                              nil,
                              @hp_options[:hp_tenant_id])


          @auth_token = data.body['access']['token']['id']

          @service_catalog =
            Fog::OpenStackCommon::ServiceCatalog.from_response(self, data.body)

          self
        end


      end # Real

    end # IdentityV2
  end # HP
end # Fog
