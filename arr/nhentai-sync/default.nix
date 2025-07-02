{
  pkgs,
  lib,
  config,
  ...
}:
let
  nhentai = import ./package.nix { inherit pkgs; };
  user = "nhentai";
in
{
  environment.systemPackages = [
    nhentai
  ];

  users.users.${user} = {
    uid = 270;
    group = "media";
    home = "${config.nixarr.stateDir}/nhentai";
    createHome = true;
  };

  systemd.services.nhentai-sync = {
    script = ''
      ${lib.getExe nhentai} \
          --favorite \
          --download \
          --save-download-history \
          --page-all \
          --cbz \
          --rm-origin-dir \
          --format "%p [nhentai-%i]" \
          --meta \
          --no-html \
          --output ${config.nixarr.mediaDir}/library/xxx/books/manga/nhentai/ \
          --delay 5
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
    };
  };

  systemd.timers.nhentai-sync = {
    wantedBy = [ "timers.target" ];
    partOf = [ "nhentai-sync.service" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "nhentai-sync.service";
    };
  };
}
