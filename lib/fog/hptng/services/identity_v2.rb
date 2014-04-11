require 'fog/openstackcommon/request_common'
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

      request_path 'fog/hptng/requests/identity/v2'

      ## Token Operations
      request :create_token
      request :validate_token
      #
      #def self.requests
      #  if @required
      #   superclass.requests + (@requests || [])
      #  else
      #    @requests || []
      #  end
      #end
      #
      #def self.models
      #  if @required
      #    superclass.models + (@models || [])
      #  else
      #    @models || []
      #  end
      #end
      #
      #def self.mocked_requests
      #  if @required
      #    superclass.mocked_requests + (@mocked_requests || [])
      #  else
      #    @mocked_requests
      #  end
      #end
      #
      #def self.collections
      #  if @required
      #    superclass.collections + (@collections  || [])
      #  else
      #    @collections || []
      #  end
      #end

      # minimal requirement
      class Mock
      end


      class Real < Fog::OpenStackCommon::IdentityV2::Real

        def initialize(options={})
           super
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
