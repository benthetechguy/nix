{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    thunderbird
    protonmail-bridge
    ungoogled-chromium
    libreoffice-fresh
    remmina
    virt-manager
    discord
    element-desktop
    file
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
