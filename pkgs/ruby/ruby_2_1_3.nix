{
  ruby,
  fetchurl,
  openssl_1_0_2,
  buildRubyGem
}:

let
  ruby_2_1_3 = (ruby.overrideAttrs (oldAttrs: {
    name = "ruby-2.1.3";
    version = "2.1.3";
    rubyEngine = "2.1.3";

    src = fetchurl {
      url = "https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz";
      sha256 = "0818beb7b10ce9a058cd21d85cfe1dcd233e98b7342d32e9a5d4bebe98347f01";
    };

    patches = [];
    postPatch = "";
    postUnpack = "";
  })).override {
    openssl = openssl_1_0_2;
  };
in
  ruby_2_1_3