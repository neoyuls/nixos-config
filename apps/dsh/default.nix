{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs_22,
  pnpm,
  git,
  ripgrep,
}:
# @deepseek-ai/dsh is a thin launcher; the pinned manifests beside this file are the
# whole source. To bump: edit package.json, `npm install --package-lock-only`, then
# refresh npmDepsHash with `nix run nixpkgs#prefetch-npm-deps -- package-lock.json`.
buildNpmPackage {
  pname = "deepseek-harness";
  version = "0.1.5-rc.1";

  # manifests only, so editing this file does not invalidate the dependency tree
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [./package.json ./package-lock.json];
  };

  npmDepsHash = "sha256-nF4bI60N9umTF0K3iLrPJkjQK/fKy2nRjlOzlw/JqsI=";

  nodejs = nodejs_22;

  # prebuilt from the registry; pruning would strip packages resolved at boot
  dontNpmBuild = true;
  dontNpmPrune = true;

  nativeBuildInputs = [makeWrapper];

  # --expose-internals is rejected in NODE_OPTIONS, so it must be on node's own
  # command line or profile boot fails; dsh shells out to pnpm, git and rg at runtime
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/dsh
    cp -r node_modules package.json $out/lib/dsh/

    makeWrapper ${nodejs_22}/bin/node $out/bin/dsh \
      --add-flags "--expose-internals" \
      --add-flags "$out/lib/dsh/node_modules/@deepseek-ai/dsh/lib/bin.js" \
      --prefix PATH : ${lib.makeBinPath [nodejs_22 pnpm git ripgrep]}

    runHook postInstall
  '';

  meta = {
    description = "DeepSeek Harness (dsh), an everything-is-a-plugin agent harness";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = lib.licenses.mit;
    mainProgram = "dsh";
    platforms = lib.platforms.linux;
  };
}
