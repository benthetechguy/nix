{ config, lib, pkgs, ... }:

{

  imports = let
    commit = "b549832718b8946e875c016a4785d204fcfc2e53";
  in [
    "${builtins.fetchTarball {
      url = "https://github.com/Mic92/sops-nix/archive/${commit}.tar.gz";
      sha256 = "11vbiaiv51ncz6di4m1wyghcvysya6zhhpfd3v70rp319wi28lyj";
    }}/modules/sops"
  ];
  sops.defaultSopsFile = ../secrets.yaml;
  sops.gnupg.sshKeyPaths = [ "/etc/ssh/idrsa" ];
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
