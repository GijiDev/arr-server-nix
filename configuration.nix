{ config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules
    ./secrets

    ./core.nix
    ./arr.nix
  ];

  services.discord-music-bot = {
    enable = true;
    settingsFile = config.age.secrets.discord-music-bot.path;
  };
}
