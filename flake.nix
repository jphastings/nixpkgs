{
  description = "Tools made by JP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Automatically discover all packages in /pkgs directory
        packageNames = builtins.attrNames (builtins.readDir ./pkgs);

        # Build each package
        packages = builtins.listToAttrs (
          map (name: {
            name = name;
            value = pkgs.callPackage ./pkgs/${name} { inherit system; };
          }) packageNames
        );
      in
      {
        packages = packages;
      }
    );
}
