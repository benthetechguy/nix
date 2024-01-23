{ config, lib, ... }:

{

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-partlabel/Linux";
    allowDiscards = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/ESP";
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
