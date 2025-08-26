{
  username,
  nixpkgs,
  home,
  inputs,
  self,
  ...
}:
let
  genConf =
    host:
    { pkgs, username, ... }@args:
    inputs.haumea.lib.load {
      src = ./${host};
      inputs = args // {
        inherit inputs;
      };
      transformer = inputs.haumea.lib.transformers.liftDefault;
    };

  genNixosSystem = host: system: modules: {
    "${host}" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        (genConf "${host}")
        (genConf "general")
        inputs.self.nixosModules.default
        inputs.determinate.nixosModules.default
      ] ++ modules;
      specialArgs = {
        inherit inputs username home;
      };
    };
  };
  inherit (nixpkgs.lib) mkMerge;
in
mkMerge [
  (genNixosSystem "bin" "x86_64-linux" [
    ./bin/_hardware.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.minegrub.nixosModules.default
    inputs.disko.nixosModules.disko
    # inputs.niri.nixosModules.niri
    { nix.registry.self.flake = self; }
  ])
]
