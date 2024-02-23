{ config, lib, ... }:

{

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-partlabel/Linux";
    allowDiscards = true;
  };

}
