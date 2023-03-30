{ lib, 
  fetchFromGitHub,
  buildGoModule,
  fetchYarnDeps,
  stdenv,
  yarn,
  nodejs,
  git,
  fixup_yarn_lock
}:

buildGoModule rec {
  pname = "alice-lg";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "alice-lg";
    repo = "alice-lg";
    rev = version;
    hash = "sha256-BdhbHAFqyQc8UbVm6eakbVmLS5QgXhr06oxoc6vYtsM=";
  };

  vendorSha256 = "sha256-SNF46uUTRCaa9qeGCfkHBjyo4BWOlpRaTDq+Uha08y8=";

  ui = stdenv.mkDerivation {
    pname = "alice-lg-ui";
    src = "${src}/ui";
    inherit version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "yarn.lock";
      sha256 = "sha256-NeK9IM8E2IH09SVH9lMlV3taCmqwlroo4xzmv4Q01jI=";
    };

    nativeBuildInputs = [ nodejs yarn git ];
    configurePhase = ''
      runHook preConfigure

      # Yarn and bundler wants a real home directory to write cache, config, etc to
      export HOME=$NIX_BUILD_TOP/fake_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror $yarnOfflineCache

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock

      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules/
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      ./node_modules/.bin/react-scripts build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      
      ls -la
      mv build $out

      runHook postInstall
    '';


    #yarnNix = ./yarn.nix;
    #packageJSON = src + "/ui/package.json";
    #yarnLock = src + "/ui/yarn.lock";

    #NODE_ENV = "production";


    #buildPhase = ''
    #  runHook preBuild
    #  export HOME=$(mktemp -d)
    #  export WRITABLE_NODE_MODULES="$(pwd)/tmp"
    #  mkdir -p "$WRITABLE_NODE_MODULES"
    #  cd ui
    #  node_modules="$(readlink node_modules)"
    #  rm node_modules
    #  mkdir -p "$WRITABLE_NODE_MODULES"/.cache
    #  cp -r $node_modules/* "$WRITABLE_NODE_MODULES"
    #  #mkdir -p "$WRITABLE_NODE_MODULES"/.bin
    #  #for x in "$node_modules"/.bin/*; do
    #  #ln -sfv "$node_modules"/.bin/"$(readlink "$x")" "$WRITABLE_NODE_MODULES"/.bin/"$(basename "$x")"
    #  #done
    #  #ln -sfv "$WRITABLE_NODE_MODULES" node_modules

    #  yarn --offline build

    #  #rm -rf node_modules
    #  #ln -sf $node_modules node_modules

    #  cd ..
    #  runHook postbuild
    #'';

    #distPhase = "true";

    #configurePhase = ''
    #  cp -r $node_modules node_modules
    #  chmod +w node_modules
    #  #chmod -R +w /homeless-shelter 
    #'';


    #dontFixup = true;
  };

  preBuild  = ''
    cp -R ${ui}/ ui/build/
  '';

  subPackages = [ "cmd/alice-lg" ];
  doCheck = false;
  
  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ janik ];
  };
}
