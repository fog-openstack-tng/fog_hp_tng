require_relative '../spec_helper'

require 'fog/hptng'

Excon.defaults[:ssl_verify_peer] = false

describe Fog::Identity::HpTng::Real do

  let(:valid_options) {
  {
    :provider           => 'HpTng',
    :hp_avl_zone        => "#{Fog.credentials[:hp_avl_zone]}",
    :hp_auth_uri        => "#{Fog.credentials[:hp_auth_uri]}",
    :hp_access_key      => "#{Fog.credentials[:hp_access_key]}",
    :hp_secret_key      => "#{Fog.credentials[:hp_secret_key]}",
    :hp_tenant_name      => "#{Fog.credentials[:hp_tenant_name]}",
    :hp_use_upass_auth_style => true,

    :connection_options => {:proxy => 'http://localhost:8888'}
  }

  }

  describe "#initialize" do


    describe "endpoint version 2" do
      describe "credentials" do
        describe "valid auth", :vcr do

          let(:connection) { Fog::Identity.new(valid_options) }

          it "must not be nil" do
            connection.wont_be_nil
          end

          it "must login succesfully" do
            connection.auth_token.wont_be_nil
          end

          #[:current_user, :current_tenant, :unscoped_token].each do |attrib|
          #  it { connection.must_respond_to attrib }
          #end

          it '#current_user' do
            connection.current_user.wont_be_nil
          end

          it '#current_tenant' do
            connection.current_tenant.wont_be_nil
          end

          it '#unscoped_token' do
            connection.unscoped_token.wont_be_nil
          end

        end


      end




    end

  end



end
