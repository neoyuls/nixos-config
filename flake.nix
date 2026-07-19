{
  description = "yuls nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    cyberdream.url = "github:scottmckendry/cyberdream.nvim";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    stylix,
    nvf,
    noctalia,
    cyberdream,
    spicetify-nix,
    ...
  }: let
    local = import (
      if builtins.pathExists ./local.nix
      then ./local.nix
      else ./local.nix.example
    );
  in {
    lib.mkFirefoxApp = pkgs: {
      appName,
      categories,
      wmClass,
      desktopName,
      icon,
      profile,
      url,
    }: let
      launcher = pkgs.writeShellScriptBin appName ''
        exec ${pkgs.firefox}/bin/firefox \
          --profile "$HOME/.mozilla/firefox/${profile}" \
          --no-remote \
          --name "${wmClass}" \
          "${url}" \
          "$@"
      '';
      desktopItem = pkgs.makeDesktopItem {
        name = appName;
        desktopName = desktopName;
        exec = "${launcher}/bin/${appName}";
        icon = "${icon}";
        categories = categories;
        startupWMClass = wmClass;
      };
    in
      pkgs.symlinkJoin {
        name = appName;
        paths = [launcher desktopItem];
      };

    lib.mkChromiumApp = pkgs: {
      appName,
      categories,
      class,
      desktopName,
      icon,
      profile,
      url,
    }: let
      launcher = pkgs.writeShellScriptBin appName ''
        exec ${pkgs.chromium}/bin/chromium \
          --profile-directory="${profile}" \
          --app="${url}" \
          "$@"
      '';
      desktopItem = pkgs.makeDesktopItem {
        name = appName;
        desktopName = desktopName;
        exec = "${launcher}/bin/${appName}";
        icon = "${icon}";
        categories = categories;
        startupWMClass = class;
      };
    in
      pkgs.symlinkJoin {
        name = appName;
        paths = [launcher desktopItem];
      };

    nixosConfigurations.${local.hostName} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit local;};
      modules = [
        stylix.nixosModules.stylix # and this
        ./system/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${local.username} = import ./home/home.nix;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = {inherit cyberdream inputs local;};
          home-manager.sharedModules = [nvf.homeManagerModules.nvf noctalia.homeModules.default spicetify-nix.homeManagerModules.default];
        }
      ];
    };
  };
}
