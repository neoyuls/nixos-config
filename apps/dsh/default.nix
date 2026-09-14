{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs_22,
  pnpm,
  git,
  ripgrep,
}:
# DeepSeek Harness publishes @deepseek-ai/dsh as a thin launcher whose ~520
# transitive packages carry the actual harness, so the pinned dependency
# manifest beside this file is the whole source. Bumping the version means
# editing package.json, re-running `npm install --package-lock-only`, and
# refreshing npmDepsHash with `nix run nixpkgs#prefetch-npm-deps -- package-lock.json`.
buildNpmPackage {
  pname = "deepseek-harness";
  version = "0.1.5-rc.1";

  # Only the manifests are inputs; keeping default.nix out of src means editing
  # this file does not invalidate the fetched dependency tree.
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [./package.json ./package-lock.json];
  };

  npmDepsHash = "sha256-nF4bI60N9umTF0K3iLrPJkjQK/fKy2nRjlOzlw/JqsI=";

  nodejs = nodejs_22;

  # Everything arrives prebuilt from the registry; there is no build step, and
  # pruning would strip packages the profiles resolve at boot.
  dontNpmBuild = true;
  dontNpmPrune = true;

  nativeBuildInputs = [makeWrapper];

  # cordis-plugin-hmr reads node's internal module loader, which only exists
  # under --expose-internals. node rejects that flag inside NODE_OPTIONS
  # (process.allowedNodeEnvironmentFlags excludes it), so it has to sit on the
  # interpreter's own command line or every profile boot dies with
  # "--expose-internals is required for HMR service".
  #
  # pnpm is a runtime dependency: `dsh plugin` forwards to it inside
  # $DSH_HOME/profiles/<name>, and the bash/search tools shell out to git and rg.
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
