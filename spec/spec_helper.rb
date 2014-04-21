require 'simplecov'
require "multi_json"
SimpleCov.start do
    add_filter "/spec/"
end


require 'minitest/autorun'
require 'minitest/spec'
require 'vcr'
require "minitest-vcr"
require "webmock"
require "minitest/reporters"

VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
    c.debug_logger = $stdout
    c.filter_sensitive_data('<PASSWORD>') { "#{Fog.credentials[:hp_secret_key]}" }
    c.filter_sensitive_data('<USERNAME>') { "#{Fog.credentials[:hp_access_key]}" }
    c.filter_sensitive_data('<TENANTID>') { "#{Fog.credentials[:hp_tenant_id]}" }
    c.filter_sensitive_data('<TENANTNAME>'){ "#{Fog.credentials[:hp_tenant_name]}" }
    c.before_record do |i|

      hp_account_number = /"user":\s+{\s+"id":\s+"([^"]+)",\s+"name":\s+"([^"]+)"/.match(i.response.body).captures[0]
      hp_account_name =   /"user":\s+{\s+"id":\s+"([^"]+)",\s+"name":\s+"([^"]+)"/.match(i.response.body).captures[1]
      role_ids= /"roles":\s+\[(.*)\]\s+},\s+"serviceCatalog":/m.match(i.response.body).captures
      role_ids.each do |role_id|
          i.response.body.sub!(role_id,"")
      end
      i.response.body.sub!(/HPAuth10_(\w*)/,"HPAuth10_<TOKEN>")
      i.response.body.sub!(hp_account_number, "<ACCOUNTNUM>")
      i.response.body.sub!(hp_account_name, "<ACCOUNTNAME>")
    end
end

MinitestVcr::Spec.configure!
#Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
