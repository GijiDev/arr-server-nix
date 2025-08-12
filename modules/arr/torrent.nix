{ transmission-protonvpn, ... }:
{
  nixarr.transmission = {
    enable = true;
    vpn.enable = true;
    extraSettings = {
      rpc-host-whitelist = "transmission.worldline.local";
      ratio-limit-enabled = true;
      ratio-limit = 2.0;
    };
  };

  # VPN Port Forwarding
  # ProtonVPN requires some wacky hacks: https://protonvpn.com/support/port-forwarding-manual-setup/
  systemd.services.transmission-protonvpn = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    description = "ProtonVPN Transmission Port Forwarding Service";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${transmission-protonvpn.packages.x86_64-linux.default}/bin/transmission-protonvpn-nat-pmp -transmission.url http://192.168.15.1:9091 -gateway.ip 10.2.0.1 -period 45s -verbose";
    };
  };
  systemd.services.transmission-protonvpn.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg"; # This must be "wg", that's what nixarr uses
  };
}
