require 'multi_json'
require 'fog/core'
require 'fog/openstackcommon/identity/adapters/authenticator_v2'

module Fog
  module HpTng
    module Authentication
      module Adapters
        module AuthenticatorV2
          extend Fog::OpenStackCommon::Authentication::Adapters::AuthenticatorV2

          #this method is invoked by Fog::OpenStackCommon::Authentication::Adapters::AuthenticatorV2#request_tokens
          #default behavior is to return a request of the form "passwordCredentials"
          def self.authenticate_request(request, options = {})
            api_key     = options[:openstack_api_key].to_s
            username    = options[:openstack_username].to_s
            tenant      = options[:openstack_tenant].to_s
            auth_token  = options[:openstack_auth_token] || options[:unscoped_token]
            uri         = options[:openstack_auth_uri]


            if options[:openstack_use_upass_auth_style]
              request[:auth][:passwordCredentials] = {
                :username => username,
                :password => api_key
              }
            else
              request[:auth][:apiAccessKeyCredentials] = {
                :accessKey => username,
                :secretKey => api_key
              }
            end

            if tenant
              request[:auth][:tenantId] = tenant
            end

            request
          end


        end # AuthenticatorV2
      end # Adapters
    end # Authentication
  end # OpenStack
end # Fog
