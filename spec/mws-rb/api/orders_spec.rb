require 'spec_helper'

describe MWS::API::Orders do
  let(:connection) do
    MWS::Connection.new(aws_access_key_id: 'access key',
                        aws_secret_access_key: 'secret key',
                        seller_id: 'seller id',
                        mws_auth_token: 'auth token')
  end

  let(:orders) { MWS::API::Orders.new(connection) }

  it 'should inheritance from MWS::API::Base' do
    expect(MWS::API::Orders.superclass).to eq(MWS::API::Base)
  end

  it 'should set the right :uri' do
    expect(orders.uri).to eq('/Orders/2013-09-01')
  end

  it 'should set the right :version' do
    expect(orders.version).to eq('2013-09-01')
  end
end
