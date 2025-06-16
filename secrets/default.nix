{ agenix, config, ... }:
{
  environment.systemPackages = [ agenix.packages.x86_64-linux.default ];

  age.secrets = {
    discord-music-bot = {
      file = ./discord-music-bot.age;
      owner = config.services.discord-music-bot.user;
      group = config.services.discord-music-bot.group;
    };
  };
}
