{ pkgs, ... }:
{
  nixarr = {
    recyclarr = {
      # TRaSH Guides Sync
      enable = true;
      configFile = ./recyclarr-config.yaml;
    };

    prowlarr.enable = true; # Search
    radarr.enable = true; # Movies
    radarr-anime.enable = true; # Movies (Anime)
    sonarr.enable = true; # TV
    sonarr-anime.enable = true; # TV (Anime)

    whisparr = {
      # XXX
      enable = true;
      package = pkgs.whisparr.overrideAttrs (
        # Use eros (v3) branch
        finalAttrs: previousAttrs:
        let
          inherit (previousAttrs) pname;
          version = "3.1.0.2093";
          hash = "sha256-H/4NeKTmZTtVMzxha0hAJsbipx0qcF7cW1EOZAYABPw=";
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
}
