{
  firewall.enable = false;
  hostName = "bin";
  useDHCP = false;

  networkmanager.enable = true;
  proxy = {
    default = "http://10.3.50.50:7890";
    noProxy = "127.0.0.1,localhost,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16";
  };
  # useNetworkd = true;
}
