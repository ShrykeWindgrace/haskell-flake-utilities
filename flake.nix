{
  description = "Flake with haskell-related flake utility functions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packagePostOverrides = pkg: with pkgs.haskell.lib.compose; pkgs.lib.pipe pkg [
          disableExecutableProfiling
          disableLibraryProfiling
          dontBenchmark
          dontCoverage
          dontDistribute
          dontHaddock
          dontHyperlinkSource
          doStrip
          enableDeadCodeElimination
          dontCheck
          justStaticExecutables
        ];
        shellNoCC = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; };
      });
}
