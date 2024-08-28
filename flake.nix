{
  inputs.disko.url = "github:nix-community/disko";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    disko,
    nixpkgs,
    self,
  }: let
    amazon-image-evaled = {
      lib,
      modulesPath,
      pkgs,
      ...
    } @ args:
      lib.filterAttrsRecursive (n: v: n != "fileSystems") (import "${modulesPath}/virtualisation/amazon-image.nix" args);
  in {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./test.nix
        amazon-image-evaled
        disko.nixosModules.disko
        {
          boot.kernelParams = ["nvme_core.io_timeout=4294967295"];
          boot.loader.efi.efiSysMountPoint = "/boot/efi";
          ec2.efi = true;
        }
        ({config, ...}: {
          system.stateVersion = config.system.nixos.version;
          disko.devices.disk.root.imageSize = "20G";
        })
      ];
    };
  };
}
