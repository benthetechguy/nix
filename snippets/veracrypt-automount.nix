{ config, lib, pkgs, ... }:

{

  imports = let
    commit = "b549832718b8946e875c016a4785d204fcfc2e53";
  in [
    "${builtins.fetchTarball {
      url = "https://github.com/Mic92/sops-nix/archive/${commit}.tar.gz";
      sha256 = "982d0204de0c45ad827003c5e1733fbdf084307e0d3f0638cc216b756dfe2de7";
    }}/modules/sops"
  ];
  sops.defaultSopsFile = ./secrets.yaml;
  sops.gnupg.home = "/var/lib/sops";
  sops.gnupg.sshKeyPaths = [];
  sops.secrets.veracrypt_key = {};

  fileSystems."/mnt/c" = {
    device = "/dev/mapper/cryptwin";
    fsType = "ntfs3";
    options = [ "noauto" "x-systemd.automount" ];
  };

  systemd.services.cryptwin = {
    script = "cat /run/secrets/veracrypt_key | cryptsetup tcryptOpen --tcrypt-system --veracrypt /dev/disk/by-partlabel/Windows cryptwin";
    preStop = "cryptsetup close cryptwin";
    path = [ pkgs.cryptsetup.bin ];
    requiredBy = [ "mnt-c.mount" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

}
