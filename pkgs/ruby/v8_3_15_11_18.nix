{
  ruby,
  fetchgit,
  stdenv,
  fetchFromGitHub,
  which,
  darwin,
  xcbuild,
  readline,
  icu,
  python,
}:

let
  version = "3.15.11.18";

  gyp = fetchgit {
    url = "https://chromium.googlesource.com/external/gyp.git";
    rev = "f7bc250ccc4d619a1cf238db87e5979f89ff36d7";
    sha256 = "IoWw6Skp6q+1WVDotfFHSwQHYkf1ydF9sVuAdKyyORA=";
  };
in
  stdenv.mkDerivation {
    pname = "v8";
    inherit version;

    src = fetchFromGitHub {
      owner = "v8";
      repo = "v8";
      rev = version;
      sha256 = "20MIKzpTkbW53BkHmkVGg1FazaNRZlFnhQxcSOH+UQM=";
    };

    postUnpack = ''
      mkdir -p "$sourceRoot/build/gyp"
      cp -r ${gyp}/* $sourceRoot/build/gyp
      chmod u+w -R $sourceRoot/build/gyp
    '';

    nativeBuildInputs = [ which darwin.DarwinTools xcbuild ];

    buildInputs = [ readline icu python ];

    GYP_DEFINES="clang=1 mac_deployment_target=10.12";

    buildFlags = [
      "native"
      "CXXFLAGS=\"-Wno-error\""
      "CXX=\"clang++\""
      "CC=\"clang\""
      "LD=\"clang++\""
      "library=shared"
      "snapshot=on"
      "console=readline"
    ];

    installPhase = ''
      install -vD out/native/d8 "$out/bin/d8"
      ${if stdenv.isDarwin then ''
      install -vD out/native/libv8.dylib "$out/lib/libv8.dylib"
      '' else ''
      install -vD out/native/lib.target/libv8.so "$out/lib/libv8.so"
      ''}
      cp -vr include "$out/"
    '';

    postFixup = if stdenv.isDarwin then ''
      install_name_tool -change /usr/local/lib/libv8.dylib $out/lib/libv8.dylib $out/bin/d8
      install_name_tool -id $out/lib/libv8.dylib $out/lib/libv8.dylib
    '' else null;
  }
