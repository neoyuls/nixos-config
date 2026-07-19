{pkgs}: let
  bin = pkgs.stdenv.mkDerivation rec {
    pname = "sldl-unwrapped";
    version = "2.6.0";
    src = pkgs.fetchurl {
      url = "https://github.com/fiso64/sldl/releases/download/v${version}/sldl_linux-x64.zip";
      sha256 = "0cybhkids9cifhvc4bmrvn7sywa5j68kawgwcr76wr28ddd420iz";
    };
    nativeBuildInputs = [pkgs.unzip];
    unpackPhase = "unzip $src";
    installPhase = "install -Dm755 sldl $out/bin/sldl";
    dontPatchELF = true;
    dontFixup = true;
  };
in
  pkgs.buildFHSEnv {
    name = "sldl";
    targetPkgs = pkgs: with pkgs; [icu openssl zlib libkrb5 stdenv.cc.cc.lib];
    runScript = "${bin}/bin/sldl";
  }
