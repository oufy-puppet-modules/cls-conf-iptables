# == Class: cls_conf_iptables
#
# Full description of class cls_conf_iptables here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'cls_conf_iptables':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class cls_conf_iptables($str_type,$str_rules) {

  case $str_type {
    'std': {
      class { 'firewall':
        ensure                          =>      'running',
      }
      firewallchain { 'INPUT:filter:IPv4':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      firewallchain { 'OUTPUT:filter:IPv4':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      firewallchain { 'FORWARD:filter:IPv4':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      firewallchain { 'INPUT:filter:IPv6':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      firewallchain { 'OUTPUT:filter:IPv6':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      firewallchain { 'FORWARD:filter:IPv6':
        policy                          =>      'accept',
        purge                           =>      true,
      }
    }
    'custom': {
      package {'conntrack-tools':
        ensure                          =>      installed,
      }
      class { 'firewall':
        ensure                          =>      'running',
      }
      contain   'cls_conf_iptables::pre'
      Firewall {
        require                         =>      Class['cls_conf_iptables::pre'],
      }
      firewallchain { 'INPUT:filter:IPv4':
        policy                          =>      'drop',
        purge                           =>      true,
      }
      firewallchain { 'OUTPUT:filter:IPv4':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      firewallchain { 'FORWARD:filter:IPv4':
        policy                          =>      'drop',
        purge                           =>      true,
      }
      firewallchain { 'INPUT:filter:IPv6':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      firewallchain { 'OUTPUT:filter:IPv6':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      firewallchain { 'FORWARD:filter:IPv6':
        policy                          =>      'accept',
        purge                           =>      true,
      }
      include "cls_conf_iptables::custom_rules::$str_rules"
    }
    'unmanaged': {
      package {'conntrack-tools':
        ensure                          =>      installed,
      }
    }
    default: {
      class { 'firewall':
        ensure                          =>      'stopped',
      }
    }
  }

}
