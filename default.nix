{
  nixpkgs ? import <nixpkgs> {},

  nixpkgs-21_11 ? import (fetchTarball "https://channels.nixos.org/nixpkgs-21.11-darwin/nixexprs.tar.xz") {
    localSystem = "x86_64-darwin";
  }
}:

with nixpkgs;

{
  inherit (callPackage ./pkgs/ruby { inherit nixpkgs-21_11; })
    ruby_2_1_3
    v8_3_15_11_18;

  inherit (callPackage ./pkgs/cilium-cli { inherit nixpkgs; })
    cilium-cli;
}