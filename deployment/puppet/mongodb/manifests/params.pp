# PRIVATE CLASS: do not use directly
class mongodb::params inherits mongodb::globals {
  $ensure                = true
  $mongos_ensure         = true
  $service_enable        = pick($mongodb::globals::service_enable, true)
  $service_ensure        = pick($mongodb::globals::service_ensure, 'running')
  $service_status        = $mongodb::globals::service_status
  $store_creds           = true
  $rcfile                = "${::root_home}/.mongorc.js"

  $mongos_service_enable = pick($mongodb::globals::mongos_service_enable, true)
  $mongos_service_ensure = pick($mongodb::globals::mongos_service_ensure, 'running')
  $mongos_service_status = $mongodb::globals::mongos_service_status

  # Amazon Linux's OS Family is 'Linux', operating system 'Amazon'.
  case $::osfamily {
    'RedHat', 'Linux': {

      if $mongodb::globals::manage_package_repo {
        $user        = pick($::mongodb::globals::user, 'mongod')
        $group       = pick($::mongodb::globals::group, 'mongod')
        if ($::mongodb::globals::version == undef) {
          $server_package_name   = pick($::mongodb::globals::server_package_name, 'mongodb-org-server')
          $client_package_name   = pick($::mongodb::globals::client_package_name, 'mongodb-org-shell')
          $mongos_package_name   = pick($::mongodb::globals::mongos_package_name, 'mongodb-org-mongos')
          $package_ensure        = true
          $package_ensure_client = true
          $package_ensure_mongos = true
        } else {
          # check if the version is greater than 2.6
          if(versioncmp($::mongodb::globals::version, '2.6.0') >= 0) {
            $server_package_name   = pick($::mongodb::globals::server_package_name, 'mongodb-org-server')
            $client_package_name   = pick($::mongodb::globals::client_package_name, 'mongodb-org-shell')
            $mongos_package_name   = pick($::mongodb::globals::mongos_package_name, 'mongodb-org-mongos')
            $package_ensure        = $::mongodb::globals::version
            $package_ensure_client = $::mongodb::globals::version
            $package_ensure_mongos = $::mongodb::globals::version
          } else {
            $server_package_name   = pick($::mongodb::globals::server_package_name, 'mongodb-10gen')
            $client_package_name   = pick($::mongodb::globals::client_package_name, 'mongodb-10gen')
            $mongos_package_name   = pick($::mongodb::globals::mongos_package_name, 'mongodb-10gen')
            $package_ensure        = $::mongodb::globals::version
            $package_ensure_client = $::mongodb::globals::version #this is still needed in case they are only installing the client
            $package_ensure_mongos = $::mongodb::globals::version
          }
        }
        $service_name        = pick($::mongodb::globals::service_name, 'mongod')
        $mongos_service_name = pick($::mongodb::globals::mongos_service_name, 'mongos')
        $config              = '/etc/mongod.conf'
        $mongos_config       = '/etc/mongos.conf'
        $dbpath              = '/var/lib/mongodb'
        $logpath             = '/var/log/mongodb/mongod.log'
        $pidfilepath         = '/var/run/mongodb/mongod.pid'
        $bind_ip             = pick($::mongodb::globals::bind_ip, ['127.0.0.1'])
        $fork                = true
      } else {
        # RedHat/CentOS doesn't come with a prepacked mongodb
        # so we assume that you are using EPEL repository.
        if ($::mongodb::globals::version == undef) {
          $package_ensure = true
          $package_ensure_client = true
          $package_ensure_mongos = true
        } else {
          $package_ensure = $::mongodb::globals::version
          $package_ensure_client = $::mongodb::globals::version
          $package_ensure_mongos = $::mongodb::globals::version
        }
        $user                = pick($::mongodb::globals::user, 'mongodb')
        $group               = pick($::mongodb::globals::group, 'mongodb')
        $server_package_name = pick($::mongodb::globals::server_package_name, 'mongodb-server')
        $client_package_name = pick($::mongodb::globals::client_package_name, 'mongodb')
        $mongos_package_name = pick($::mongodb::globals::mongos_package_name, 'mongodb-server')
        $service_name        = pick($::mongodb::globals::service_name, 'mongod')
        $config              = '/etc/mongodb.conf'
        $mongos_config       = '/etc/mongos.conf'
        $dbpath              = '/var/lib/mongodb'
        $logpath             = '/var/log/mongodb/mongodb.log'
        $bind_ip             = pick($::mongodb::globals::bind_ip, ['127.0.0.1'])
        if ($::operatingsystem == 'fedora' and versioncmp($::operatingsystemrelease, '22') >= 0 or
            $::operatingsystem != 'fedora' and versioncmp($::operatingsystemrelease, '7.0') >= 0) {
          $pidfilepath         = '/var/run/mongodb/mongod.pid'
        } else {
          $pidfilepath         = '/var/run/mongodb/mongodb.pid'
        }
        $fork                = true
        $journal             = true
      }
    }
    'Debian': {
      if $::mongodb::globals::manage_package_repo {
        $user  = pick($::mongodb::globals::user, 'mongodb')
        $group = pick($::mongodb::globals::group, 'mongodb')
        if ($::mongodb::globals::version == undef) {
          $server_package_name = pick($::mongodb::globals::server_package_name, 'mongodb-org-server')
          $client_package_name = pick($::mongodb::globals::client_package_name, 'mongodb-org-shell')
          $mongos_package_name = pick($::mongodb::globals::mongos_package_name, 'mongodb-org-mongos')
          $package_ensure = true
          $package_ensure_client = true
          $package_ensure_mongos = true
          $service_name = pick($::mongodb::globals::service_name, 'mongod')
          $config = '/etc/mongod.conf'
        } else {
          # check if the version is greater than 2.6
          if(versioncmp($::mongodb::globals::version, '2.6.0') >= 0) {
            $server_package_name = pick($::mongodb::globals::server_package_name, 'mongodb-org-server')
            $client_package_name = pick($::mongodb::globals::client_package_name, 'mongodb-org-shell')
            $mongos_package_name = pick($::mongodb::globals::mongos_package_name, 'mongodb-org-mongos')
            $package_ensure = $::mongodb::globals::version
            $package_ensure_client = $::mongodb::globals::version
            $package_ensure_mongos = $::mongodb::globals::version
            $service_name = pick($::mongodb::globals::service_name, 'mongod')
            $config = '/etc/mongod.conf'
          } else {
            $server_package_name = pick($::mongodb::globals::server_package_name, 'mongodb-10gen')
            $client_package_name = pick($::mongodb::globals::client_package_name, 'mongodb-10gen')
            $mongos_package_name = pick($::mongodb::globals::mongos_package_name, 'mongodb-10gen')
            $package_ensure = $::mongodb::globals::version
            $package_ensure_client = $::mongodb::globals::version #this is still needed in case they are only installing the client
            $service_name = pick($::mongodb::globals::service_name, 'mongodb')
            $config = '/etc/mongodb.conf'
          }
        }
        $mongos_service_name = pick($::mongodb::globals::mongos_service_name, 'mongos')
        $mongos_config       = '/etc/mongos.conf'
        $dbpath              = '/var/lib/mongodb'
        $logpath             = '/var/log/mongodb/mongodb.log'
        $bind_ip             = pick($::mongodb::globals::bind_ip, ['127.0.0.1'])
      } else {
        # although we are living in a free world,
        # I would not recommend to use the prepacked
        # mongodb server on Ubuntu 12.04 or Debian 6/7,
        # because its really outdated
        if ($::mongodb::globals::version == undef) {
          $package_ensure = true
          $package_ensure_client = true
          $package_ensure_mongos = true
        } else {
          $package_ensure = $::mongodb::globals::version
          $package_ensure_client = $::mongodb::globals::version
          $package_ensure_mongos = $::mongodb::globals::version
        }
        $user                = pick($::mongodb::globals::user, 'mongodb')
        $group               = pick($::mongodb::globals::group, 'mongodb')
        $server_package_name = pick($::mongodb::globals::server_package_name, 'mongodb-server')
        $client_package_name = $::mongodb::globals::client_package_name
        $mongos_package_name = pick($::mongodb::globals::mongos_package_name, 'mongodb-server')
        $service_name        = pick($::mongodb::globals::service_name, 'mongodb')
        $mongos_service_name = pick($::mongodb::globals::mongos_service_name, 'mongos')
        $config              = '/etc/mongodb.conf'
        $mongos_config       = '/etc/mongos.conf'
        $dbpath              = '/var/lib/mongodb'
        $logpath             = '/var/log/mongodb/mongodb.log'
        $bind_ip             = pick($::mongodb::globals::bind_ip, ['127.0.0.1'])
        $pidfilepath         = $::mongodb::globals::pidfilepath
      }
      # avoid using fork because of the init scripts design
      $fork = undef
    }
    default: {
      fail("Osfamily ${::osfamily} and ${::operatingsystem} is not supported")
    }
  }

  case $::operatingsystem {
    'Ubuntu': {
      $service_provider = pick($service_provider, 'upstart')
    }
    default: {
      $service_provider = undef
    }
  }

}
