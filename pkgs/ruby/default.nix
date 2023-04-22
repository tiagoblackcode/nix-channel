{
  
}:

rec {
  nixpkgs-21_11 = import (fetchTarball "https://channels.nixos.org/nixpkgs-21.11-darwin/nixexprs.tar.xz") {
    localSystem = "x86_64-darwin";
  };

  ruby_2_1_3 = nixpkgs-21_11.callPackage ./ruby_2_1_3.nix {};

  v8_3_15_11_18 = nixpkgs-21_11.callPackage ./v8_3_15_11_18.nix {
    ruby = ruby_2_1_3;
  };
}