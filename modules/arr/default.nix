{
  imports = [
    ./media-clients.nix
    ./nhentai-sync
    ./starr.nix
    ./torrent.nix
  ];

  nixarr = {
    enable = true;
    mediaDir = "/media/media";
    stateDir = "/media/media/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = "/media/.secrets/wg.conf";
    };
  };
}
