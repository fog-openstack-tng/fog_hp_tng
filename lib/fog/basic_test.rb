require "./hptng"

Excon.defaults[:ssl_verify_peer] = false

options = {
  :provider          => 'HpTng',
  :hp_avl_zone => "#{Fog.credentials[:hp_avl_zone]}",
  :hp_auth_uri => "#{Fog.credentials[:hp_auth_uri]}",
  :hp_access_key => "#{Fog.credentials[:hp_access_key]}",
  :hp_secret_key => "#{Fog.credentials[:hp_secret_key]}",
  :hp_tenant_id => "#{Fog.credentials[:hp_tenant_id]}",
  :hp_use_upass_auth_style => false,

  :connection_options => {:proxy => 'http://localhost:8888'}
}

 x = Fog::Identity.new(options)

 x.check_token(12345,nil)

