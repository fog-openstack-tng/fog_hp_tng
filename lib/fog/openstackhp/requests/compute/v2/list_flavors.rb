module Fog
  module OpenStackHp
    class ComputeV2
      class Real

        # List all flavors (IDs and names only)
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #   * 'minDisk'<~Integer> - Filters the list of flavors to those with the specified minimum number of gigabytes of disk storage.
        #   * 'minRam'<~Integer> - Filters the list of flavors to those with the specified minimum amount of RAM in megabytes.
        #   * 'marker'<~String> - The ID of the last item in the previous list
        #   * 'limit'<~Integer> - Sets the page size
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~String> - UUId of the flavor
        #     * 'name'<~String> - Name of the flavor
        #     * 'links'<~Array> - array of flavor links
        def list_flavors(options = {})
          request(
            :expects => [200, 203],
            :method  => 'GET',
            :path    => 'flavors',
            :query   => options
          )
        end

      end

      class Mock


      end
    end
  end
end