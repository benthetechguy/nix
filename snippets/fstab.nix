{ config, lib, ... }:

{

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/Linux";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
    "/mnt/NAS" = {
      device = "192.168.1.248:/mnt/NAS";
      fsType = "nfs4";
      options = [ "_netdev" "noauto" "x-systemd.automount" ];
    };
  };

  swapDevices = [ {
    device = "/dev/disk/by-partlabel/Swap";
    randomEncryption.enable = true;
    randomEncryption.allowDiscards = true;
  } ];

}
