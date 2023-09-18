# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, unstablePkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.supportedFilesystems = [ "zfs" ];
  #boot.zfs.forceImportRoot = false;
  #boot.zfs.extraPools = [ "zfstest" ];
  #services.zfs.autoScrub.enable = true;

  time.timeZone = "America/Denver";

  users.users.britton = 
  {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    # hashedPassword = "$6$wW/xsljhhG/vssC3$ujh/4jSZp7APUsbI6FAAUtIkaWVl9ElocFV6FKO7vD4ouoXKiebecrfmtd46NNVJBOFO8blNaEvkOLmOW5X3j.";
  };
  users.users.britton.openssh.authorizedKeys.keyFiles = [
    ./../../authorized_keys
  ];
  users.users.root.openssh.authorizedKeys.keyFiles = [
    ./../../authorized_keys
  ];

  services.openssh = 
  {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  environment.systemPackages = import ./../../common/common-packages.nix
  { 
    pkgs = pkgs; 
    unstablePkgs = unstablePkgs; 
  };

  virtualisation = 
  {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # services = {
  #   xserver = {
  #     enable = true;
  #     displayManager = {
  #       lightdm.enable = true;
  #       defaultSession = "xfce";
  #       #defaultSession = "xfce+bspwm";
  #     };
  #     desktopManager.xfce.enable = true;
  #     windowManager.bspwm.enable = true;
  #   };
  # };

  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
    # enable the tailscale service
  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey tskey-auth-kVZxwS5CNTRL-GLuJns73a7WZLLEhGjbREWa83TAWTGpTV'';
  };

  services.sshd.enable = true;
  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [ 22 ];
  };
  #system.copySystemConfiguration = true;
  system.stateVersion = "23.05";

}