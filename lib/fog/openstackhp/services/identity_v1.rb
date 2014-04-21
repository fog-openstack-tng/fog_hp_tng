require 'fog/OpenStackHp/request_common'
require 'fog/openstackcore/service_catalog'
require 'fog/openstackcore/services/identity_v1'

module Fog
  module OpenStackHp
    class IdentityV1 < Fog::OpenStackCore::IdentityV1

      requires :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes :hp_auth_uri, :credentials, :hp_service_type, :hp_tenant_name
      recognizes :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes :hp_access_key
      secrets :hp_secret_key

      request_path 'fog/openstackhp/requests/identity/v1'

      ## Token Operations
      request :create_token

      # minimal requirement
      class Mock
      end


      class Real < Fog::OpenStackCore::IdentityV1::Real

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
          return auth_with_credentials
        end

        def auth_with_credentials


          data = create_token(@options[:hp_access_key],
                              @options[:hp_secret_key])


          @auth_token = data.headers['X-Auth-Token']

          @service_catalog =
            Fog::OpenStackCore::ServiceCatalog.from_response(self, data.body)
          self
        end


      end # Real

    end # IdentityV2
  end # HP
end # Fog
