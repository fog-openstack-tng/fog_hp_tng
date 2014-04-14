require 'multi_json'
require 'fog/hptng/errors'

module Fog
  module HpTng
    extend Fog::Provider
    include Fog::HpTng::Errors

    service(:identity,      'Identity')
#     service(:compute ,      'Compute')
#     service(:image,         'Image')
#     service(:network,       'Network')
#     service(:storage,       'Storage')
#     service(:volume,        'Volume')
#     service(:metering,      'Metering')
#     service(:orchestration, 'Orchestration')



  end   # HpTng
end   # FOG
