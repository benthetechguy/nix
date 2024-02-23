{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../snippets/systemd-boot.nix
    ../snippets/luks.nix
    ../snippets/fstab.nix
    ../snippets/veracrypt-automount.nix
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" "evdi" ];
  boot.extraModulePackages = [ ];

  boot.loader.systemd-boot = {
    editor = false;
    extraEntries = {
      "windows.conf" = ''
      title Microsoft Windows 11
      efi /EFI/VeraCrypt/DcsBoot.efi
      '';
      "ipxe.conf" = ''
      title iPXE
      efi /ipxe.efi
      '';
    };
    extraFiles = {
      "ipxe.efi" = "${pkgs.ipxe}/ipxe.efi";
    };
    extraInstallCommands = ''
    echo "timeout menu-force" | ${pkgs.coreutils}/bin/tee -a /boot/loader/loader.conf
    echo "auto-entries false" | ${pkgs.coreutils}/bin/tee -a /boot/loader/loader.conf
    '';
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "nix360";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      libva-utils
      rocmPackages.clr.icd
    ];
  };
}
