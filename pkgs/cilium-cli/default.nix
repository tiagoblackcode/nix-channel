{
  nixpkgs ? import <nixpkgs> { }
}:

let
  version = "0.13.2";

  src = nixpkgs.fetchFromGitHub {
    owner = "cilium";
    repo = "cilium-cli";
    rev = "v${version}";
    sha256 = "sha256-K/RUEr9WJU1tocESvBF48F890vMgCRANM0lqn644eeg=";
  };

in

{
  cilium-cli = nixpkgs.cilium-cli.override rec {
    buildGoModule = args: nixpkgs.buildGoModule(args // {
      inherit src version;

      ldflags = [
        "-s" "-w"
        "-X github.com/cilium/cilium-cli/internal/cli/cmd.Version=${version}"
      ];

      patches = [];

      installCheckPhase = ''
        $out/bin/cilium version | grep ${version} > /dev/null
      '';
    });
  };
}
