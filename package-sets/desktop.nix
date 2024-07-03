{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    thunderbird
    protonmail-bridge
    ungoogled-chromium
    libreoffice-fresh
    remmina
    vlc
    virt-manager
    monero-gui
    handbrake
    discord
    element-desktop
    prismlauncher
    file
    htop
    sshfs
    screen
    p7zip
    corefonts
    android-tools
  ];

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

}
