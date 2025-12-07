{
  pkgs,
  config,
  poetry2nix,
  ...
}:
let
  inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
  nhentaiApp = mkPoetryApplication {
    projectDir = pkgs.fetchFromGitHub {
      owner = "RicterZ";
      repo = "nhentai";
      rev = "0.6.0-beta";
      hash = "sha256-NIorZ5ZxoPzTfvMCM2oAE0uiPFya4L/Anacoy9D/79U=";
    };
  };

  user = "nhentai";
in
{
  environment.systemPackages = [
    nhentaiApp
  ];

  users.users.${user} = {
    uid = 270;
    group = "media";
    home = "${config.nixarr.stateDir}/nhentai";
    createHome = true;
  };

  systemd.services.nhentai-sync = {
    script = ''
      ${nhentaiApp}/bin/nhentai \
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
