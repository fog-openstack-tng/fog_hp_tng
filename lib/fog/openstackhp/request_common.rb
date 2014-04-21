require 'fog/OpenStackHp/errors'

module Fog
  module OpenStackHp
    module RequestCommon

      def base_request(service, params)

        first_attempt = true
        begin

          rp = request_params(params)
          response = service.request(rp)
        rescue Excon::Errors::Conflict => error
          raise Fog::OpenStackHp::Errors::Conflict.slurp(error)
        rescue Excon::Errors::BadRequest => error
          raise Fog::OpenStackHp::Errors::BadRequest.slurp(error)
        rescue Excon::Errors::Unauthorized => error
          raise error unless first_attempt
          first_attempt = false
          retry
        rescue Excon::Errors::HTTPStatusError => error
          raise case error
                  when Excon::Errors::NotFound
                    raise Fog::OpenStackHp::Errors::NotFound.slurp(error)
                  else
                    error
                end
        end
        unless response.body.empty?
          response.body = Fog::Json.decode(response.body)
        end

        response

      end


      def request_params(params)
        params.merge({
                       :headers => headers(params),
                       :path    => params[:path]
                     })
      end

      def headers(options={})
        # puts "\nINSIDE HEADERS"
        # puts "OPTIONS: #{options.to_yaml}"

        headers =
          {'Content-Type' => 'application/json',
           'Accept'       => 'application/json'
          }.merge(options[:headers] || {})
        headers.merge!('X-Auth-Token' => @auth_token) if @auth_token

        headers
      end

    end # BaseRequest
  end # HP
end # Fog
