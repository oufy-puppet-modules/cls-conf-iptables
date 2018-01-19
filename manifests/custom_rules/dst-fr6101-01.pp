class cls_conf_iptables::pre {
  Firewall {
    require => undef,
  }

  firewall { '000 accept all icmp':
    proto                       =>      'icmp',
    action                      =>      'accept',
  } ->
  firewall { '001 accept all to lo interface':
    proto                       =>      'all',
    iniface                     =>      'lo',
    action                      =>      'accept',
  } ->
  firewall { '002 INPUT accept related established rules':
    proto                       =>      'all',
    state                       =>      ['RELATED', 'ESTABLISHED'],
    action                      =>      'accept',
  } ->
  firewall { "005 accept ssh INPUT traffic":
    action                      =>      'accept',
    port                        =>      '22',
    proto                       =>      'tcp',
    chain                       =>      'INPUT',
    table                       =>      'filter',
    state                       =>      'NEW',
  }
}
[root@mgt-fr6101-01 manifests]# :1
-bash: :1 : commande introuvable
[root@mgt-fr6101-01 manifests]# ll
total 8
drwxr-xr-x. 2 puppet root   52 11 déc.   2014 custom_rules
-rw-r--r--  1 puppet root 2002 27 févr.  2015 init.pp
-rw-r--r--. 1 puppet root  635  2 déc.   2014 pre.pp
[root@mgt-fr6101-01 manifests]# cd custom_rules/
[root@mgt-fr6101-01 custom_rules]# ll
total 8
-rw-r--r--. 1 puppet root 2314 11 déc.   2014 dst-fr6101-01.pp
-rw-r--r--. 1 puppet root 1692 11 déc.   2014 vpn-fr6101-01.pp
[root@mgt-fr6101-01 custom_rules]# cat dst-fr6101-01.pp
class cls_conf_iptables::custom_rules::dst-fr6101-01 {

  sysctl { 'net.ipv4.ip_forward': value => '1' }

  firewall { '002 FORWARD accept related established rules':
    proto                       =>      'all',
    state                       =>      ['RELATED', 'ESTABLISHED'],
    action                      =>      'accept',
    chain                       =>      'FORWARD',
  }

  firewall {'110 INPUT accept cobbler traffic':
    proto                       =>      'tcp',
    action                      =>      'accept',
    chain                       =>      'INPUT',
    table                       =>      'filter',
    dport                       =>      ['80','443','25151'],
    state                       =>      'NEW',
  }

  firewall {'130 INPUT accept openvpn traffic':
    proto                       =>      'tcp',
    action                      =>      'accept',
    chain                       =>      'INPUT',
    table                       =>      'filter',
    dport                       =>      ['8443'],
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

  firewall {'120 FORWARD accept local traffic towards Internet':
    proto                       =>      'all',
    action                      =>      'accept',
    chain                       =>      'FORWARD',
    table                       =>      'filter',
    source                      =>      '172.20.0.0/14',
    state                       =>      'NEW',
  }

  firewall {'100 POSTROUTING eth0 masquerade openvpn traffic':
    table                       =>      'nat',
    chain                       =>      'POSTROUTING',
    outiface                    =>      'eth0',
    jump                        =>      'MASQUERADE',
    proto                       =>      'all',
  }

#  firewall {'100 POSTROUTING eth2 masquerade openvpn traffic':
#    table                      =>      'nat',
#    chain                      =>      'POSTROUTING',
#    outiface                   =>      'eth2',
#    jump                       =>      'MASQUERADE',
#    proto                      =>      'all',
#  }

  firewall {'100 POSTROUTING eth3 masquerade openvpn traffic':
    table                       =>      'nat',
    chain                       =>      'POSTROUTING',
    outiface                    =>      'eth3',
    jump                        =>      'MASQUERADE',
    proto                       =>      'all',
  }

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

