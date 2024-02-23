{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "mac";
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      ncln = "sudo nix-collect-garbage -d";
      nupd = "sudo nixos-rebuild switch";
      nupg = "sudo nixos-rebuild switch --upgrade";
    };
  };
  users.defaultUserShell = pkgs.fish;
  users.users.ben = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    nano
    openssh
    nix-index
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Ben Westover";
        email = "me@benthetechguy.net";
        signingKey = "C311C5F54E89B698";
      };
      commit.gpgSign = true;
      tag.gpgSign = true;
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
}
