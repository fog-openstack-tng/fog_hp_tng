require "fog/openstackhp"

Excon.defaults[:ssl_verify_peer] = false

options = {
  :provider          => :openstackhp,
  :hp_avl_zone => "#{Fog.credentials[:hp_avl_zone]}",
  #:hp_auth_uri => "#{Fog.credentials[:hp_auth_uri]}",
  :hp_access_key => "#{Fog.credentials[:hp_access_key]}",
  :hp_secret_key => "#{Fog.credentials[:hp_secret_key]}",
  :hp_tenant_id => "#{Fog.credentials[:hp_tenant_id]}",

 :connection_options => {
     :proxy => 'http://localhost:8888'
 #    :instrumentor => Excon::StandardInstrumentor,
 #    :connect_timeout => 10,
 #    :read_timeout => 10,
 #    :write_timeout => 10,
 #    :ssl_verify_peer => false
  }
 #:user_agent => "MyApp/x.x.x",
}



 x = Fog::Identity.new(options)


y = Fog::Compute.new(options.merge(:version => 2))
y.list_flavors




