{ config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules
    ./secrets
    ./arr

    ./core.nix
  ];

  services.discord-music-bot = {
    enable = true;
    settingsFile = config.age.secrets.discord-music-bot.path;
  };
}
