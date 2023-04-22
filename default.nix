{
  nixpkgs ? import <nixpkgs> {}
}:

with nixpkgs;

{
  inherit (callPackage ./pkgs/ruby {})
    ruby_2_1_3
    v8_3_15_11_18;

  inherit (callPackage ./pkgs/cilium-cli {})
    cilium-cli;
}