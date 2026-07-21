{
  stdenv,
  fetchFromGitHub,
  cmake,
  qt5,
  libGL,
  libGLU,
}:
stdenv.mkDerivation {
  pname = "depthmapx";
  version = "unstable-2024";

  src = fetchFromGitHub {
    owner = "SpaceGroupUCL";
    repo = "depthmapX";
    rev = "02ceaec015452fda5b3b2a8c66bb06787e7b02a0"; # pinned for reproducibility (was "master")
    hash = "sha256-XoCVxEGUJF6jqnDWRHblQMTIrYq12ZSjOn0V4tTAFas=";
  };

  nativeBuildInputs = [cmake qt5.wrapQtAppsHook];
  buildInputs = [qt5.qtbase libGL libGLU];

  installPhase = ''
    mkdir -p $out/bin
    cp depthmapX/depthmapX $out/bin/
    cp depthmapXcli/depthmapXcli $out/bin/
  '';
}
