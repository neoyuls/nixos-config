{
  config,
  lib,
  pkgs,
  local,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      # openldap tests fail in sandboxed builds due to network access
      openldap = prev.openldap.overrideAttrs (_: {doCheck = false;});
    })
  ];
  imports = [
    ./hardware.nix
    ./lemurs.nix
  ];

  # Stylix
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = ../assets/lain-rose.yaml;
    image = ../assets/wallpapers/lain_wp_1.jpg; # required by stylix
    targets.kmscon.enable = false;
  };
  # BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.kernelModules = ["ntsync"];
  # int340x_thermal conflicts with manual RAPL power capping (rapl-power-limit service below).
  # Disabling ACPI thermal zones lets the 45W MMIO RAPL limit govern CPU TDP instead.
  boot.kernelParams = ["thermal.off=1"];
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };

  # Kernel patch: fix MT7961 Bluetooth WMT FUNC_CTRL short response (EINVAL)
  boot.blacklistedKernelModules = ["int340x_thermal"];

  # Network
  networking.hostName = local.hostName; # Define your hostname.
  networking.networkmanager.enable = true;

  # Locale & Time
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "es_MX.UTF-8";

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="rfkill", ATTR{type}=="bluetooth", ATTR{soft}="0"
    # ADB/USB Android devices
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0660", GROUP="adbusers", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0660", GROUP="adbusers", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", MODE="0660", GROUP="adbusers", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0660", GROUP="adbusers", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="2717", MODE="0660", GROUP="adbusers", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="2a70", MODE="0660", GROUP="adbusers", TAG+="uaccess"
  '';

  # NVIDIA 4060
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    # hybrid graphics settings
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Wayland / Niri
  programs.niri.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glib
      libGL
      libGLU

      gdal
      proj
      geos
      sqlite
      libxml2
      curl

      zstd
      lz4
      bzip2
      xz
      openssl
    ];
  };
  # seatd: the upstream unit uses Type=notify wrapped in s6-notify-socket-from-fd,
  # but the readiness signal never reaches systemd, so seatd is killed at the 90s
  # start-timeout while niri is already a client -- niri then panics with ENOTCONN
  # from libseat. Drop the wrapper and run seatd directly as Type=simple.
  systemd.services.seatd.serviceConfig = {
    Type = lib.mkForce "simple";
    ExecStart = lib.mkForce "${pkgs.seatd}/bin/seatd -u root -g seat -l debug";
    NotifyAccess = lib.mkForce "none";
  };

  # Capture niri crashes/logs persistently so we can diagnose recurrences.
  services.journald.storage = "persistent";
  # xdg-desktop-portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
  #upower
  services.upower.enable = true;

  # MMIO RAPL platform power limit
  systemd.services.rapl-power-limit = {
    description = "Set MMIO RAPL CPU power limit to 45W";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/sh -c 'echo 45000000 > /sys/class/powercap/intel-rapl-mmio/intel-rapl-mmio:0/constraint_0_power_limit_uw'";
    };
  };
  powerManagement.cpuFreqGovernor = "schedutil";

  # Audio - PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    wireplumber.extraConfig = {
      "50-disable-seat-monitoring" = {
        "wireplumber.profiles".main."monitor.bluez.seat-monitoring" = "disabled";
      };
    };
    extraConfig.pipewire."92-high-quality-audio" = {
      "context.properties" = {
        "default.clock.rate" = 96000;
        "default.clock.allowed-rates" = [44100 48000 88200 96000];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 8192;
        "resample.quality" = 10;
      };
    };
    extraConfig.pipewire-pulse."92-high-quality" = {
      "context.properties" = {
        "resample.quality" = 10;
      };
    };
  };
  # Security
  security.rtkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lemurs.enableGnomeKeyring = true;

  # sudo
  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = ["NOPASSWD "];
          }
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.systemd}/bin/poweroff";
            options = ["NOPASSWD"];
          }
          {
            command = "${config.security.wrapperDir}/mount";
            options = ["NOPASSWD"];
          }
          {
            command = "${config.security.wrapperDir}/umount";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  services.blueman.enable = true;
  systemd.services.rfkill-unblock-bluetooth = {
    description = "Unblock Bluetooth rfkill";
    wantedBy = ["bluetooth.service"];
    before = ["bluetooth.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      RemainAfterExit = true;
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = ["JetBrains Mono"];
    sansSerif = ["Noto Sans"];
    serif = ["Noto Serif"];
  };

  services.journald.extraConfig = ''
    SystemMaxUse=256M
    RuntimeMaxUse=64M
  '';

  # VM settings
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
  programs.virt-manager.enable = true;
  # Users
  users.groups.adbusers = {};
  users.defaultUserShell = pkgs.zsh;
  users.users.${local.username} = {
    isNormalUser = true;
    description = local.username;
    uid = 1000;
    extraGroups = ["wheel" "seat" "networkmanager" "video" "audio" "input" "libvirtd" "kvm" "bluetooth" "adbusers"];
  };

  programs.zsh.enable = true;

  # Nix settings
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    max-jobs = 8;
    cores = 4;
    min-free = 5368709120;
    max-free = 10737418240;
  };
  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19" # required by zotero (qt5 dep, no upstream fix yet)
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [
      stdenv.cc.cc.lib
      zlib
      libGL
    ]);
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  documentation.dev.enable = true;
  documentation.man.cache.enable = true;
  # System Packages
  environment.systemPackages = with pkgs; [
    # core
    wget
    stress-ng
    curl
    btop
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    tree
    unzip
    yazi
    chroma
    fuzzel
    pdftk

    # Network tools
    proton-vpn
    networkmanager-openvpn
    rclone
    thunderbird
    proton-pass
    protonmail-desktop

    # Python3

    (python3.withPackages (ps:
      with ps; [
        mutagen
        geopandas
        shapely
        fiona
        rasterio
        pyproj
        matplotlib
        jupyter
        folium
        numpy
        pandas
        ipython
      ]))

    # Dev
    micromamba
    grass
    alejandra
    gcc
    gnumake
    cmake
    pkg-config
    norminette
    bear
    nodejs_22
    rustup
    gdb
    valgrind
    gdal
    claude-code
    opencode

    # Man pages
    man-pages
    man-pages-posix

    # geospatial
    qgis

    # Gaming / Battle.net
    lutris
    wineWow64Packages.staging
    winetricks
    mindustry

    # Notes and documents
    obsidian
    zotero
    onlyoffice-desktopeditors

    # Media
    yt-dlp
    image-roll
    easyeffects
    flac
    nicotine-plus
    youtube-tui
    stremio-linux-shell
    mpv
    ffmpeg
    termusic

    # Downloads
    qbittorrent

    # Misc
    discord
    adb-sync
    android-tools

    (pkgs.callPackage ../apps/sldl.nix {})
  ];

  # Programs needing system integration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  services.ratbagd.enable = true; # required daemon for piper

  # Services
  services.openssh.enable = false;
  services.printing = {
    enable = true;
    drivers = [pkgs.epson-escpr2]; # note the 2
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ZRAM as swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # Firewall
  networking.firewall = {
    enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment? Yes I did :)
}
