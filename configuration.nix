{
  imports = [
    ./hardware-configuration.nix
    ./modules/arr
    ./modules/auto-rebuild.nix
    ./modules/core.nix
    ./modules/proxmox.nix
    ./modules/reverse-proxy
  ];
}
