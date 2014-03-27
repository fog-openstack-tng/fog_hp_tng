require 'multi_json'
require 'fog/core'
require 'fog/openstackcommon/identity/adapters/authenticator_v2'

module Fog
  module HpTng
    module Authentication
      module Adapters
        module AuthenticatorV2

          def self.authenticate(options, connection_options = {})

            uri                   = options[:openstack_auth_uri]
            tenant_name           = options[:openstack_tenant]
            service_type          = options[:openstack_service_type]
            service_name          = options[:openstack_service_name]
            identity_service_type = options[:openstack_identity_service_type]
            openstack_region      = options[:openstack_region]
            user_password_style   = options[:openstack_use_upass_auth_style] || true
            body = request_tokens(options, connection_options)
            service = get_service(body, service_type, service_name)

            #Note the scoped token stuff is deleted, seems contrary to OS,
            #also the unscoped stuff.

            if openstack_region
              service['endpoints'] = get_endpoints(service['endpoints'])
            end

            ensure_service_available(service, body['access']['serviceCatalog'], service_type)

            raise_error_if_multiple_endpoints(service['endpoints'])

            tenant         = body['access']['token']['tenant']
            user           = body['access']['user']
            identity_url   = identity_service['endpoints'].detect { |s| s['publicURL'] }['publicURL'] if service

            return {
              :user                     => user,
              :tenant                   => tenant,
              :identity_public_endpoint => identity_url,
              :token                    => body['access']['token']['id'],
              :expires                  => body['access']['token']['expires'],
              :current_user_id          => body['access']['user']['id'],
            }

          end


          private


          def self.get_service(body, service_type=[], service_name=nil)
            body['access']['serviceCatalog'].detect do |s|
              if service_name.nil? or service_name.empty?
                service_type.include?(s['type'])
              else
                service_type.include?(s['type']) and s['name'] == service_name
              end
            end
          end


          def self.get_endpoints(endpoints)
            ep = endpoints.select { |endpoint| endpoint['region'] == openstack_region }
            if ep.empty?
              raise Fog::Errors::NotFound.new("No endpoints available for region '#{openstack_region}'")
            end
          end

          def self.ensure_service_available(service, service_catalog, service_type)
            unless service
              available = service_catalog.map { |endpoint| endpoint['type'] }.sort.join ', '
              missing = service_type.join ', '
              raise Fog::Errors::NotFound, "Could not find service #{missing}.  Have #{available}"
            end
          end

          def self.raise_error_if_multiple_endpoints(endpoints)
            if endpoints.count > 1
              regions = endpoints.map { |e| e['region'] }.uniq.join(',')
              raise Fog::Errors::NotFound.new("Multiple regions available choose one of these '#{regions}'")
            end
          end

          def self.request_tokens(options, connection_options = {})


            api_key      = options[:openstack_api_key].to_s
            username     = options[:openstack_username].to_s
            tenant_name  = options[:openstack_tenant].to_s
            auth_token   = options[:openstack_auth_token] || options[:unscoped_token]
            uri          = options[:openstack_auth_uri]
            username_password_form = options[:openstack_use_upass_auth_style]

            connection   = Fog::Core::Connection.new(uri.to_s, false, connection_options)

            request_body = create_authenticate_request_body(username_password_form, api_key,auth_token, tenant_id,tenant_name, username)

            response = connection.request({
                                            :expects => [200, 204],
                                            :headers => {'Content-Type' => 'application/json'},
                                            :body    => MultiJson.encode(request_body),
                                            :method  => 'POST',
                                            :path    => (uri.path and not uri.path.empty?) ? uri.path : 'v2.0'
                                          })


            MultiJson.decode(response.body)
          end

          def self.create_authenticate_request_body(user_password_style,api_key, auth_token,tenant_id, tenant_name, username)
            request_body = {:auth => Hash.new}

            if auth_token
              request_body[:auth][:token] = {:id => auth_token}
            else
              if user_password_style
                #vanilla openstack
                request_body[:auth][:passwordCredentials] = {
                  :username => username,
                  :password => api_key
               }
              else{
              #this part is specific to HPC.. will differ for Rackspace

               request_body[:auth][:apiAccessKeyCredentials] = {}
                request_body[:auth][:apiAccessKeyCredentials] = {
                  :accessKey => username,
                  :secretKey => api_key
                }

              }
              end

              if tenant_id
                request_body[:auth][:tenantId] = tenant_id
              elsif tenant_name
                #vanilla openstack
                request_body[:auth][:tenantName] = tenant_name
              end
            end

            request_body
          end

        end # AuthenticatorV2
      end # Adapters
    end # Authentication
  end # OpenStack
end # Fog
