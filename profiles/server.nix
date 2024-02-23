{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ../package-sets/server.nix
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  users.users."ben".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTr9plLUqDty+JGFYAtvubcVUaBLUF4/7G759uSJbzIY5LpRfNBBMRFYezZMbFkOvW2DmQG7aLqXDdyEX/kKW2uskViCcF8Is1i7ZjooLDFyhv0TDDMUMb24VV9uwq/I2/TV3t+4yDcxxFyZJNBf40K+ELKcZXiq7jnjNszD4UnJFnsZAmp+2Q8VyRABQqwpVCUw9vROh5NAWKABvizBcDeZJlYweGJiwYRy7kmfuWkEVls4nE08fWRGMD8p8M2H0b891eboak0338aBUQP0hCfo687tbhyZqZWzuxsPkIeacg4OjHupQhDwMLq5M29m7gkVObQbFSP5QfDJEuYkkE4wKyhu+ZZexw0kpgaOrM0NmnkSJTUqSY7kk9PD1E77EMJf9EPePuLMy3L92rvPaOeQpJUdWBloyi0FXNCKsUxy0MT07/lMFiEGHnKHb1FsuZ/MbE7Tk709zBGyUIrkvNs4Nymyl2OhUj0hS/WHesyUNS0RyrbAUL494+P/I+jSs="
  ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  services.plex = {
    enable = true;
    openFirewall = true;
    user = "ben";
  };
}
