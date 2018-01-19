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

