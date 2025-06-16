{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) fetchurl;
  version = "0.4.3";
  src = fetchurl {
    url = "https://github.com/jagrosh/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
    hash = "sha256-7CHFc94Fe6ip7RY+XJR9gWpZPKM5JY7utHp8C3paU9s=";
  };
  cfg = config.services.discord-music-bot;
in
{
  options.services.discord-music-bot = with lib; {
    enable = mkEnableOption "Discord Music Bot";

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/discord-music-bot";
      description = ''
        The state directory where songs/playlists are stored. 
      '';
    };

    settingsFile = mkOption {
      type = types.path;
      description = ''
        Path to the settings file for Discord Music Bot.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "discord-music-bot";
      description = "User under which Discord Music Bot runs";
    };

    group = mkOption {
      type = types.str;
      default = "discord-music-bot";
      description = "Group under which Discord Music Bot runs";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.discord-music-bot = {
      description = "Discord Music Bot";
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        WorkingDirectory = cfg.stateDir;
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        ExecStart = "${pkgs.jdk11}/bin/java -Dconfig=${cfg.settingsFile} -Dnogui=true -jar ${src}";
        Restart = "always";
        RestartSec = 10;
      };
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      home = cfg.stateDir;
      createHome = true;
      homeMode = "755";
      group = cfg.group;
    };
    users.groups.${cfg.group} = { };

  };
}
