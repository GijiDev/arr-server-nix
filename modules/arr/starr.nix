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
  };

  services.flaresolverr = {
    enable = true;
    openFirewall = true;
  };
}
