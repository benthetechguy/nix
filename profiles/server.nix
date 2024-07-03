{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ../package-sets/server.nix
  ];

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
  sops.secrets.nextcloud_admin_pass = {};
  sops.secrets.cloudflare_bttg_cert = {};
  sops.secrets.cloudflare_bttg_key = {};
  sops.secrets.cloudflare_tsc_cert = {};
  sops.secrets.cloudflare_tsc_key = {};
  sops.secrets.nas_pass = {};
  sops.secrets.nas_pass_2 = {};

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  users.users."ben".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTr9plLUqDty+JGFYAtvubcVUaBLUF4/7G759uSJbzIY5LpRfNBBMRFYezZMbFkOvW2DmQG7aLqXDdyEX/kKW2uskViCcF8Is1i7ZjooLDFyhv0TDDMUMb24VV9uwq/I2/TV3t+4yDcxxFyZJNBf40K+ELKcZXiq7jnjNszD4UnJFnsZAmp+2Q8VyRABQqwpVCUw9vROh5NAWKABvizBcDeZJlYweGJiwYRy7kmfuWkEVls4nE08fWRGMD8p8M2H0b891eboak0338aBUQP0hCfo687tbhyZqZWzuxsPkIeacg4OjHupQhDwMLq5M29m7gkVObQbFSP5QfDJEuYkkE4wKyhu+ZZexw0kpgaOrM0NmnkSJTUqSY7kk9PD1E77EMJf9EPePuLMy3L92rvPaOeQpJUdWBloyi0FXNCKsUxy0MT07/lMFiEGHnKHb1FsuZ/MbE7Tk709zBGyUIrkvNs4Nymyl2OhUj0hS/WHesyUNS0RyrbAUL494+P/I+jSs="
  ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  services.nginx = {
    virtualHosts = {
      "default" = {
        default = true;
        addSSL = true;
        sslCertificate = "/run/secrets/cloudflare_bttg_cert"
        sslCertificateKey = "/run/secrets/cloudflare_bttg_key"
        root = "/var/www/website";
        extraConfig = ''
          autoindex on;
          error_page 404 /404.html;
        '';
        locations = {
          "/" = {
            index = "index.html index.php";
          };
          "~ \\.php$" {
            extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools.pool.socket};
              fastcgi_index index.php;
            '';
          };
          "/404.html" = {
            extraConfig = "internal;";
          };
          "/NAS" = {
            basicAuthFile = "/run/secrets/nas_pass";
          };
          "/nas" = {
            basicAuthFile = "/run/secrets/nas_pass_2";
          };
          "^~ /.git" = {
            return 403;
          };
        };
      };

      "apt.benthetechguy.net" = {
        forceSSL = true;
        sslCertificate = "/run/secrets/cloudflare_bttg_cert"
        sslCertificateKey = "/run/secrets/cloudflare_bttg_key"
        root = "/mnt/NAS/mirrors/reprepro";
        locations = {
          "/" = {
            index = "index.html";
          };
          "/debian" = {
            extraconfig = "autoindex on;";
          };
          "^~ /conf" = {
            return 403;
          };
          "^~ /db" = {
            return 403;
          };
          "^~ /incoming" = {
            return 403;
          };
          "^~ /changes.sh" = {
            return 403;
          };
        };
      };

      "nextcloud.benthetechguy.net" = {
        forceSSL = true;
        sslCertificate = "/run/secrets/cloudflare_bttg_cert"
        sslCertificateKey = "/run/secrets/cloudflare_bttg_key"
      };

      "www.techsupportcentral.org" = {
        forceSSL = true;
        sslCertificate = "/run/secrets/cloudflare_tsc_cert"
        sslCertificateKey = "/run/secrets/cloudflare_tsc_key"
        serverAliases = [ "s1.techsupportcentral.org" ];
        root = "/var/www/tsc";
        locations = {
          "/" = {
            index = "index.html index.php";
          };
          "~ \\.php$" {
            extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools.pool.socket};
              fastcgi_index index.php;
            '';
          };
          "^~ /.git" = {
            return 403;
          };
          "^~ /.github" = {
            return 403;
          };
          "^~ /.gitignore" = {
            return 403;
          };
          "^~ /includes/config.php" = {
            return 403;
          };
        };
      };
    };
  };

  services.phpfpm.pools.pool = {
    user = "nobody";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };

  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.benthetechguy.net";
    package = pkgs.nextcloud28;
    database.createLocally = true;
    configureRedis = true;

    maxUploadSize = "16G";
    https = true;
    enableBrokenCiphersForSSE = false;

    autoUpdateApps.enable = true;
    extraAppsEnable = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit calendar contacts notes tasks end_to_end_encryption twofactor_totp;
    };

    config = {
      overwriteProtocol = "https";
      defaultPhoneRegion = "US";
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/run/secrets/nextcloud_admin_pass";
    };
  };
}
