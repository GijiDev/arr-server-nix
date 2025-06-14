{ transmission-protonvpn, ... }:
{
  nixarr = {
    enable = true;
    mediaDir = "/media/media";
    stateDir = "/media/media/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = "/media/.secrets/wg.conf";
    };

    jellyfin.enable = true; # Shows
    komga.enable = true; # Manga

    transmission = {
      enable = true;
      vpn.enable = true;
    };

    prowlarr.enable = true; # Search
    jellyseerr.enable = true; # Web Search & Request

    radarr.enable = true; # Movies
    sonarr.enable = true; # TV
    whisparr.enable = true; # XXX
  };

  services.flaresolverr = {
    enable = true;
    openFirewall = true;
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
      ExecStart = "${transmission-protonvpn.packages.x86_64-linux.default}/bin/transmission-protonvpn-nat-pmp -transmission.url http://192.168.15.1:9091 -gateway.ip 10.2.0.1 -period 45s";
    };
  };
  systemd.services.transmission-protonvpn.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg"; # This must be "wg", that's what nixarr uses
  };

  networking.firewall = {
    # Open ports for Jellyseerr
    allowedTCPPorts = [ 5055 ];
  };
}
