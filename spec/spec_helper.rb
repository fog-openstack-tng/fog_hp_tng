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
    # c.debug_logger = $stdout

      #

      #
end

MinitestVcr::Spec.configure!
#Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
