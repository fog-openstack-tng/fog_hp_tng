require 'simplecov'
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
      i.request.body.sub!("#{Fog.credentials[:hp_tenant_id]}", "<TENANTID>")
    end
end

MinitestVcr::Spec.configure!
#Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
