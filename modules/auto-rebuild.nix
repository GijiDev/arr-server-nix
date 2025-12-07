{
  system.autoUpgrade = {
    enable = true;
    flake = "github:GijiDev/arr-server-nix";
    dates = "*-*-* 04:00"; # 4AM daily

    allowReboot = true;
    rebootWindow = {
      lower = "02:00";
      upper = "06:00";
    };

    runGarbageCollection = true;
  };
}
