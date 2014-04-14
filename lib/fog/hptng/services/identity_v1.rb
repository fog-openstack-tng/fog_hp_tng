require 'fog/hptng/request_common'
require 'fog/openstackcommon/service_catalog'
require 'fog/openstackcommon/services/identity_v1'

module Fog
  module HpTng
    class IdentityV1 < Fog::OpenStackCommon::IdentityV1

      requires :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes :hp_auth_uri, :credentials, :hp_service_type, :hp_tenant_name
      recognizes :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes :hp_access_key
      secrets :hp_secret_key

      request_path 'fog/hptng/requests/identity/v1'

      ## Token Operations
      request :create_token

      # minimal requirement
      class Mock
      end


      class Real < Fog::OpenStackCommon::IdentityV1::Real

        def initialize(options={})
          super
        end

        private

        def authenticate
          return auth_with_credentials
        end

        def auth_with_credentials


          data = create_token(@options[:hp_access_key],
                              @options[:hp_secret_key])


          @auth_token = data.headers['X-Auth-Token']

          @service_catalog =
            Fog::OpenStackCommon::ServiceCatalog.from_response(self, data.body)
          self
        end


      end # Real

    end # IdentityV2
  end # HP
end # Fog
