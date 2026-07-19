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
    rev = "master"; # pin to a commit hash for reproducibility
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
