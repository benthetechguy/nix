{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ../package-sets/desktop.nix
  ];

  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    xkb = {
      layout = "us";
      variant = "mac";
    };
  };
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "plasmawayland";
  };
  services.libinput.enable = true;
  programs.dconf.enable = true;

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
