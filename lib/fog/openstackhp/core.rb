require 'fog/json'
require 'fog/openstackhp/errors'
require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackHp
    extend Fog::Provider
    include Fog::OpenStackHp::Errors

    Fog::OpenStackCore::ServiceDiscovery.register_provider('openstackhp', 'Fog::OpenStackHp', 'fog/openstackhp/services')

    service(:identity,      'Identity')
#     service(:compute ,      'Compute')
#     service(:image,         'Image')
#     service(:network,       'Network')
#     service(:storage,       'Storage')
#     service(:volume,        'Volume')
#     service(:metering,      'Metering')
#     service(:orchestration, 'Orchestration')



  end   # OpenStackHp
end   # FOG
