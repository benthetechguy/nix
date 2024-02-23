{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    protonmail-bridge
    virt-manager
    monero-cli
    file
  ];

}
