module Fog
  module HpTng
    class IdentityV2
      class Real

        # require 'pry'
        # binding.pry
        def create_token(username, password, tenant_name=nil, tenant_id=nil)
          data = {}
          if @options[:hp_use_upass_auth_style]
            data = {
              'auth' => {
                'passwordCredentials' => {
                  'username' => username,
                  'password' => password
                }
              }
            }
          else
            data = {
              'auth' => {
                'apiAccessKeyCredentials' => {
                  'accessKey' => username,
                  'secretKey' => password
                }
              }
            }
          end


          if tenant_id
            data['auth'].merge!({'tenantId' => tenant_id })
          elsif tenant_name
            data['auth'].merge!({'tenantName' => tenant_name })
          end

          request(
            :method  => 'POST',
            :expects => [200, 202],
            :path    => '/v2.0/tokens',
            :body    => Fog::JSON.encode(data)
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # HP
end # Fog
