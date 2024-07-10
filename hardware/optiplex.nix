{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../snippets/fstab.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-SanDisk_SSD_G5_BICS4_202363803318";
  boot.loader.timeout = 10;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "soptiplex";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
}
