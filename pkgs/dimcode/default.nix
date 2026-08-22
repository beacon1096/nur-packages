{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "dimcode";
  version = "0.2.8";

  src = fetchurl {
    url = "https://registry.npmjs.org/dimcode-linux-x64/-/dimcode-linux-x64-${version}.tgz";
    hash = "sha256-orZczjsSG9+/KKvfJ5n0nSs+zTFzaNCxz9BMcG0xJ9s=";
  };

  sourceRoot = "package";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/dimcode $out/bin
    cp -r bin $out/lib/dimcode/
    chmod +x $out/lib/dimcode/bin/dimcode
    ln -s $out/lib/dimcode/bin/dimcode $out/bin/dim
    ln -s $out/lib/dimcode/bin/dimcode $out/bin/dimcode

    runHook postInstall
  '';

  meta = {
    description = "AI coding agent CLI and terminal coding assistant with an interactive TUI";
    homepage = "https://dimcode.dev/";
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "dim";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
