{ config, lib, pkgs, ... }:

{

  fileSystems."/mnt/c" = {
    device = "/dev/mapper/cryptwin";
    fsType = "ntfs3";
    options = [ "noauto" "x-systemd.automount" ];
  };

  systemd.services.cryptwin = {
    script = "echo 'MOllyPup12' | cryptsetup tcryptOpen --tcrypt-system --veracrypt /dev/disk/by-partlabel/Windows cryptwin";
    preStop = "cryptsetup close cryptwin";
    path = [ pkgs.cryptsetup.bin ];
    requiredBy = [ "mnt-c.mount" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

}
