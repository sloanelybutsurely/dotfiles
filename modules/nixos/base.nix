{
  config,
  lib,
  pkgs,
  ...
}:
let
  acts = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/alexjurkiewicz/acts/refs/tags/v1.4.2/acts";
    hash = "sha256-eiVBF45kOY8nRUsUa6oTzZS2Ylu5oBc75oyqe5FENFU=";
  };
  actsPkg = pkgs.runCommand "acts" { } ''
    mkdir -p $out/bin
    cp ${acts} $out/bin/acts
    chmod +x $out/bin/acts
  '';
in
{
  imports = [
    ../overlays
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.displayManager.ly.enable = true;
  services.interception-tools.enable = true; # Capslock changes

  fonts.packages = with pkgs; [ nerd-fonts.atkynson-mono ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  services.tailscale.enable = true;

  services.udisks2.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sloane = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  programs.sway.enable = true;
  programs.fish.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sloane" ];
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome
    neovim
    wget
    git
    cifs-utils
    tarsnap
    actsPkg
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  fileSystems."/media/NAS/Personal" = {
    device = "//NAS/Personal";
    fsType = "cifs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "vers=2.0"
      "credentials=/etc/nixos/smb-secrets"
      "uid=1000,gid=100"
    ];
  };

  fileSystems."/media/NAS/Media" = {
    device = "//NAS/Media";
    fsType = "cifs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "vers=2.0"
      "credentials=/etc/nixos/smb-secrets"
      "uid=1000,gid=100"
    ];
  };

  environment.etc."acts.conf" = {
    enable = true;
    text = ''
      tarsnap="${pkgs.tarsnap}/bin/tarsnap --keyfile /root/tarsnap.key --cachedir /var/cache/tarsnap"
      hostname="${config.networking.hostName}"
      backuptargets="home"
      verbose=1
      tarsnapbackupoptions="--one-file-system --humanize-numbers -v"
    '';
  };

  systemd.timers."acts" = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "acts.service";
    };
  };

  systemd.services."acts" = {
    enable = true;
    script = "${actsPkg}/bin/acts";
    requires = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      IOSchedulingClass = "idle";
      User = "root";
    };
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
