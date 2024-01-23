{ config, lib, pkgs, ... }:

{
  imports = [ ./common.nix ];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.libinput.enable = true;

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

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
  users.users.ben.extraGroups = [ "libvirtd" ];
}
