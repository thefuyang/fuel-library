require 'spec_helper'
require 'shared-examples'
manifest = 'openstack-cinder/openstack-cinder.pp'

describe manifest do
  shared_examples 'catalog' do

max_pool_size = 20
max_retries = '-1'
max_overflow = 20
rabbit_ha_queues = Noop.hiera('rabbit_ha_queues')

 it 'ensures cinder_config contains "oslo_messaging_rabbit/rabbit_ha_queues" ' do
  should contain_cinder_config('oslo_messaging_rabbit/rabbit_ha_queues').with(
    'value' => rabbit_ha_queues,
  )
 end

  it 'should declare ::cinder class with correct database_max_* parameters' do
    should contain_class('cinder').with(
      'database_max_pool_size' => max_pool_size,
      'database_max_retries'   => max_retries,
      'database_max_overflow'  => max_overflow,
    )
  end

  keystone_auth_host = Noop.hiera 'service_endpoint'
  auth_uri           = "http://#{keystone_auth_host}:5000/"
  identity_uri       = "http://#{keystone_auth_host}:5000/"

  it 'ensures cinder_config contains auth_uri and identity_uri ' do
      should contain_cinder_config('keystone_authtoken/auth_uri').with(:value  => auth_uri)
      should contain_cinder_config('keystone_authtoken/identity_uri').with(:value  => identity_uri)
  end

  end # end of shared_examples

 test_ubuntu_and_centos manifest

end
