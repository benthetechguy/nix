{ config, lib, pkgs, ... }:

{

  boot.loader.timeout = null;
  boot.loader.systemd-boot = {
    enable = true;
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
  boot.loader.efi.canTouchEfiVariables = true;

}
