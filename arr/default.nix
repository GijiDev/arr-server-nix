{
  transmission-protonvpn,
  pkgs,
  lib,
  ...
}:
let
  hostname = "worldline.local";
in
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
      extraSettings = {
        rpc-host-whitelist = "transmission.${hostname}";
        ratio-limit-enabled = true;
        ratio-limit = 2.0;
      };
    };

    recyclarr = {
      # TRaSH Guides Sync
      enable = true;

      # Would use `configuration`, but current generator breaks env var use
      configFile = ./recyclarr-config.yaml;
    };

    prowlarr.enable = true; # Search
    jellyseerr.enable = true; # Web Search & Request

    radarr.enable = true; # Movies
    radarr-anime.enable = true; # Movies
    sonarr.enable = true; # TV
    sonarr-anime.enable = true; # TV
    whisparr = {
      # XXX
      enable = true;
      package = pkgs.whisparr.overrideAttrs (
        # Use eros (v3) branch
        finalAttrs: previousAttrs:
        let
          inherit (previousAttrs) pname;
          version = "3.0.0.1127";
          hash = "sha256-XeOMEWSG98Bu4xRaon7MeN2PBrLiAAAyPzFQAsVvWw0=";
          arch = "x64";
          os = "linux";
        in
        {
          src = pkgs.fetchurl {
            name = "${pname}-${arch}-${os}-${version}.tar.gz";
            url = "https://whisparr.servarr.com/v1/update/eros/updatefile?runtime=netcore&version=${version}&arch=${arch}&os=${os}";
            inherit hash;
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

  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts =
      let
        ports = {
          jellyseerr = 5055;
          komga = 25600;
          prowlarr = 9696;
          radarr = 7878;
          radarr-anime = 7879;
          sonarr = 8989;
          sonarr-anime = 8990;
          transmission = 9091;
          whisparr = 6969;
        };
      in
      builtins.listToAttrs (
        lib.attrsets.mapAttrsToList (name: port: {
          name = "${name}.${hostname}";
          value = {
            locations."/" = {
              recommendedProxySettings = true;
              proxyWebsockets = true;
              proxyPass = "http://127.0.0.1:${builtins.toString port}";
            };
          };
        }) ports
      )
      // {
        # Jellyfin requires special handling
        # https://jellyfin.org/docs/general/post-install/networking/reverse-proxy/nginx/
        "jellyfin.${hostname}" = {
          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:8096";
              extraConfig = ''
                # Disable buffering when the nginx proxy gets very resource heavy upon streaming
                proxy_buffering off;
              '';
            };
            "/socket" = {
              recommendedProxySettings = true;
              proxyWebsockets = true;
              proxyPass = "http://127.0.0.1:8096";
            };
          };
        };
        # Default catch-all
        "_" = {
          default = true;
          locations = {
            "/" = {
              return = "404";
            };
          };
        };
      };
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 ];
  };
}
