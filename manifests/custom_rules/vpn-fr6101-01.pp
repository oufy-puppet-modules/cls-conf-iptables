class cls_conf_iptables::custom_rules::vpn-fr6101-01 {

  sysctl { 'net.ipv4.ip_forward': value => '1' }

  firewall { '002 FORWARD accept related established rules':
    proto                       =>      'all',
    state                       =>      ['RELATED', 'ESTABLISHED'],
    action                      =>      'accept',
    chain                       =>      'FORWARD',
  }

  firewall {'110 INPUT accept openvpn traffic':
    proto                       =>      'tcp',
    action                      =>      'accept',
    chain                       =>      'INPUT',
    table                       =>      'filter',
    dport                       =>      ['8443','1194'],
    state                       =>      'NEW',
  }

  firewall {'100 INPUT accept local traffic':
    proto                       =>      'all',
    action                      =>      'accept',
    chain                       =>      'INPUT',
    table                       =>      'filter',
    source                      =>      '172.20.0.0/14',
    destination                 =>      '172.20.0.0/14',
    state                       =>      'NEW',
  }

  firewall {'100 FORWARD accept local traffic':
    proto                       =>      'all',
    action                      =>      'accept',
    chain                       =>      'FORWARD',
    table                       =>      'filter',
    source                      =>      '172.20.0.0/14',
    destination                 =>      '172.20.0.0/14',
    state                       =>      'NEW',
  }

  firewall {'100 POSTROUTING eth0 masquerade openvpn traffic':
    table                       =>      'nat',
    chain                       =>      'POSTROUTING',
    outiface                    =>      'eth0',
    jump                        =>      'MASQUERADE',
    proto                       =>      'all',
  }

#  firewall {'100 POSTROUTING eth1 masquerade openvpn traffic':
#    table                      =>      'nat',
#    chain                      =>      'POSTROUTING',
#    outiface                   =>      'eth1',
#    jump                       =>      'MASQUERADE',
#    proto                      =>      'all',
#  }

  firewall {'500 LOG INPUT cleanup rule':
    table                       =>      'filter',
    chain                       =>      'INPUT',
    jump                        =>      'LOG',
  }

  firewall {'500 LOG FORWARD cleanup rule':
    table                       =>      'filter',
    chain                       =>      'FORWARD',
    jump                        =>      'LOG',
  }

}

