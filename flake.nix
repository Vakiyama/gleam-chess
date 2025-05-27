{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gleam.url = "github:arnarg/nix-gleam";
  };

  outputs =
    inputs@{ ... }:

    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devshell.flakeModule
        inputs.flake-parts.flakeModules.modules
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        { system, ... }:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system}.extend (
            inputs.nixpkgs.lib.composeManyExtensions [
              inputs.nix-gleam.overlays.default
            ]
          );
        in
        {
          _module.args.pkgs = pkgs;

          devshells.default = {
            commands = [
              { package = pkgs.gleam; }
            ];

            packages = [
              # runtimes - backend
              pkgs.erlang_27
              pkgs.rebar3
            ];
          };
        };
    };
}
