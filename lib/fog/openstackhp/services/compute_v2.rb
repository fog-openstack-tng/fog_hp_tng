require 'fog/openstackhp/request_common'
require 'fog/openstackcore/service_catalog'


module Fog
  module OpenStackHp
    class ComputeV2 < Fog::Service

      requires :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes :hp_auth_uri, :credentials, :hp_service_type
      recognizes :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes :persistent, :connection_options
      recognizes :hp_access_key, :hp_account_id # :hp_account_id is deprecated use hp_access_key instead

      secrets :hp_secret_key

      request_path 'fog/openstackhp/requests/compute/v2'

      ## Token Operations
      request :list_flavors

      # minimal requirement
      class Mock
      end


      class Real
        include Fog::OpenStackHp::RequestCommon

        def initialize(options={})
          @hp_options = options.dup
          identity = Fog::OpenStackCore::ServiceDiscovery.new(
            'openstackhp',
            'identity',
            options.merge(:version => 2)
          ).call

          @auth_token = identity.auth_token
          uri   = URI.parse(
            identity.service_catalog.get_endpoint(
              'Compute',
              options[:hp_avl_zone]
            )
          )
          @path = uri.path

          @service = Fog::Core::Connection.new(
            URI::Generic.build(
              :scheme => uri.scheme,
              :host   => uri.host,
              :port   => uri.port
            ).to_s,
            options[:persistent] || false,
            options[:connection_options] || {}
          )
        end

        def request(params)
          base_request(@service, params)
        end

        def request_params(params)
          params.merge({
                         :headers => headers(params),
                         :path    => "#{@path}/#{params[:path]}"
                       })
        end

        private

        def customize_options(options)
          opts = options.dup
          #opts.merge!(:openstack_username => opts.delete(:hp_access_key))
          #opts.merge!(:openstack_api_key => opts.delete(:hp_secret_key))
          #opts.merge!(:openstack_auth_url => opts.delete(:hp_auth_uri) || DEFAULT_AUTH_URI)
          #opts.merge!(:openstack_region => opts.delete(:hp_avl_zone))
          #opts.merge!(:openstack_tenant => opts.delete(:hp_tenant_name))
          opts
        end




      end # Real

    end # IdentityV2
  end # HP
end # Fog
