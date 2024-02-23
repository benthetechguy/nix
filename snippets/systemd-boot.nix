{ config, lib, pkgs, ... }:

{

  boot.loader.timeout = null;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

}
