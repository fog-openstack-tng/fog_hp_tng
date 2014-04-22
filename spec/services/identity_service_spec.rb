require_relative '../spec_helper'

require 'fog/openstackhp'
require 'fog/openstackhp/errors'

Excon.defaults[:ssl_verify_peer] = false

describe Fog::OpenStackHp::Identity do

  let(:valid_options) {
    {
      :provider      => :openstackhp,
      :hp_avl_zone   => "#{Fog.credentials[:hp_avl_zone]}",
      :hp_auth_uri   => "#{Fog.credentials[:hp_auth_uri]}",
      :hp_access_key => "#{Fog.credentials[:hp_access_key]}",
      :hp_secret_key => "#{Fog.credentials[:hp_secret_key]}",
      :hp_tenant_id  => "#{Fog.credentials[:hp_tenant_id]}",
      #:connection_options => {:proxy => 'http://localhost:8888'}
    }
  }

  describe "#initialize", :vcr do
    describe "when no version is specified" do
      let(:service) { Fog::Identity.new(valid_options) }
      it "returns version 2" do
        service.must_be_instance_of Fog::OpenStackHp::IdentityV2::Real
      end
    end
    describe "when version is specified" do
      describe "1" do
        it "returns version 1" do
          skip("not implemented in OSC")
          valid_options[:version] = 1
          service = Fog::Identity.new(valid_options)
          service.must_be_instance_of Fog::OpenStackHp::IdentityV1::Real
        end
      end
      describe "2" do
        it "returns version 2" do
          valid_options[:version] = 2
          service = Fog::Identity.new(valid_options)
          service.must_be_instance_of Fog::OpenStackHp::IdentityV2::Real
        end
      end
    end

    describe "#auth_with_credentials_and_tenant" do
      describe "with valid credentials" do
        let(:service) { Fog::Identity.new(valid_options)}

        it "returns an auth_token" do
          service.auth_token.wont_be_nil
        end

        [:service_catalog, :token, :auth_token, :unscoped_token,
         :current_tenant, :current_user].each do |attrib|
          it { service.must_respond_to attrib }
        end

      end
      describe "with invalid configuration" do
        describe "for password" do
          it "throws exception" do
            invalid_options = valid_options.clone
            invalid_options[:hp_secret_key] = "BadJuju"
            proc {
              Fog::Identity.new(invalid_options)
            }.must_raise Fog::OpenStackHp::Errors::Unauthorized
          end
        end
        describe "for username" do
          it "throws exception" do
            invalid_options = valid_options.clone
            invalid_options[:hp_access_key] = "BadUser"
            proc {
              Fog::Identity.new(invalid_options)
            }.must_raise Fog::OpenStackHp::Errors::Unauthorized
          end
        end
        describe "for tenant" do
          it "throws exception" do
            invalid_options = valid_options.clone
            invalid_options[:hp_tenant_id] = "IGotNothing"
            proc {
              Fog::Identity.new(invalid_options)
            }.must_raise Fog::OpenStackHp::Errors::Unauthorized
          end
        end
      end
    end

    #describe "endpoint version 2" do
    #  describe "credentials" do
    #    describe "valid auth", :vcr do
    #
    #      let(:connection) { Fog::Identity.new(valid_options) }
    #
    #      it "must not be nil" do
    #        connection.wont_be_nil
    #      end
    #
    #      it "must login succesfully" do
    #        connection.auth_token.wont_be_nil
    #      end
    #
    #      [:current_user, :current_tenant, :unscoped_token].each do |attrib|
    #        it { connection.must_respond_to attrib }
    #      end
    #
    #    end
    #
    #
    #  end

  end

end


