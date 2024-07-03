{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    protonmail-bridge
    virt-manager
    monero-cli
    p2pool
    file
    htop
    sshfs
    screen
    p7zip
  ];

}
