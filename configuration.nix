{
  imports = [
    ./hardware-configuration.nix
    ./modules/arr
    ./modules/core.nix
    ./modules/proxmox.nix
    ./modules/reverse-proxy
  ];
}
