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
          version = "3.0.0.1163";
          hash = "sha256-WcrqrQIZbs4U9lmtVUIJmrtkfpyusWI5Wcyd4PbUeBA=";
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
