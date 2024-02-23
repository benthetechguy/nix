{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ../package-sets/desktop.nix
  ];

  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "plasmawayland";
    };
    desktopManager.plasma5.enable = true;
    libinput.enable = true;
    xkb = {
      layout = "us";
      variant = "mac";
    };
  };

  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };
  boot.initrd.systemd.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
