module Fog
  module HpTng
    module Errors
      class ServiceError < Fog::Errors::Error
        attr_reader :response_data

        def self.slurp(error)
          if error.response.body.empty?
            data    = nil
            message = nil
          else
            begin
              data    = Fog::JSON.decode(error.response.body)
              message = data['message']
              if message.nil? and !data.values.first.nil?
                message = data.values.first['message']
              end
            rescue Fog::JSON::DecodeError
              message = error.response.body #### body is not in JSON format, so just return as is
            end
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@response_data, data)
          new_error
        end
      end

      class InternalServerError < ServiceError;
      end
      class Conflict < ServiceError;
      end
      class NotFound < ServiceError;
      end
      class Forbidden < ServiceError;
      end
      class ServiceUnavailable < ServiceError;
      end

      class BadRequest < ServiceError
        attr_reader :validation_errors

        def self.slurp(error)
          new_error = super(error)
          unless new_error.response_data.nil? or new_error.response_data['badRequest'].nil?
            new_error.instance_variable_set(:@validation_errors, new_error.response_data['badRequest']['validationErrors'])
          end
          new_error
        end
      end
    end
  end
end