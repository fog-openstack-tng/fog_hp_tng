require 'fog/openstackcommon/request_common'
require 'fog/openstackcommon/service_catalog'

module Fog
  module HpTng
    class IdentityV2 < Fog::Service

      requires :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes :hp_auth_uri, :credentials, :hp_service_type, :hp_tenant_name
      recognizes :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes :hp_access_key
      secrets :hp_secret_key

      request_path 'fog/hptng/requests/identity/v2'

      ## Token Operations
      request :create_token
      request :validate_token


      # minimal requirement
      class Mock
      end

      class Real < Fog::OpenStackCommon::IdentityV2::Real

        def initialize(params={})
          @options = params.clone

          # get an initial connection to Identity on port 5000 to auth
          @service = Fog::Core::Connection.new(
            @options[:hp_auth_uri].to_s,
            @options[:persistent] || false,
            @options[:connection_options] || {}
          )

          authenticate
        end

        def request(params)
          base_request(@service, params)
        end

        private

        def authenticate
          return auth_with_credentials_and_tenant
        end

        def auth_with_credentials_and_tenant


          data = create_token(@options[:hp_access_key],
                              @options[:hp_secret_key],
                              nil,
                              @options[:hp_tenant_id])


          @auth_token = data.body['access']['token']['id']

          @service_catalog =
            Fog::OpenStackCommon::ServiceCatalog.from_response(self, data.body)

          self
        end


      end # Real

    end # IdentityV2
  end # HP
end # Fog