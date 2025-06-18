{ transmission-protonvpn, pkgs, ... }:
{
  nixarr = {
    enable = true;
    mediaDir = "/media/media";
    stateDir = "/media/media/.state/nixarr";

    vpn = {
      enable = true;
      accessibleFrom = [ "10.0.0.0/24" ]; # Local network
      wgConf = "/media/.secrets/wg.conf";
    };

    jellyfin.enable = true; # Shows
    komga.enable = true; # Manga

    transmission = {
      enable = true;
      vpn.enable = true;
    };

    recyclarr = {
      # TRaSH Guides Sync
      # TODO: look into using multi-service, for now just using for anime
      enable = true;

      # Would use `configuration`, but current generator breaks env var use
      configFile = ./recyclarr-config.yaml;
    };

    prowlarr.enable = true; # Search
    jellyseerr.enable = true; # Web Search & Request

    radarr.enable = true; # Movies
    sonarr.enable = true; # TV
    whisparr = {
      # XXX
      enable = true;
      package = pkgs.whisparr.overrideAttrs (
        # Use eros (v3) branch
        finalAttrs: previousAttrs:
        let
          inherit (previousAttrs) pname;
          version = "3.0.0.1124";
          # Hardcode, could be improved for other os/arch combos later
          arch = "x64";
          os = "linux";
        in
        {
          src = pkgs.fetchurl {
            name = "${pname}-${arch}-${os}-${version}.tar.gz";
            url = "https://whisparr.servarr.com/v1/update/eros/updatefile?runtime=netcore&version=${version}&arch=${arch}&os=${os}";
            hash = "sha256-fTBhL+GRjR0EJSo0tqtp+rtRb5qaEty895lTDWW3Dyo=";
          };

        }
      );
    };
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
      ExecStart = "${transmission-protonvpn.packages.x86_64-linux.default}/bin/transmission-protonvpn-nat-pmp -transmission.url http://192.168.15.1:9091 -gateway.ip 10.2.0.1 -period 45s -verbose";
    };
  };
  systemd.services.transmission-protonvpn.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg"; # This must be "wg", that's what nixarr uses
  };
}
