{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  zlib,
  libGL,
  libxkbcommon,
  wayland,
  xorg,
  vulkan-loader,
  egl-wayland,
}:

stdenv.mkDerivation rec {
  pname = "horizon-bin";
  version = "0.2.4";

  src = fetchurl {
    url = "https://github.com/peters/horizon/releases/download/v${version}/horizon-linux-x64.tar.gz";
    hash = "sha256-T6AWAGwjiPcnP0E5gPdY/lg5JQlyDvRd8awucqD0hMA=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    zlib
    stdenv.cc.cc.lib # libgcc_s
  ];

  runtimeDependencies = [
    libGL
    libxkbcommon
    vulkan-loader
    wayland
    egl-wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libxcb
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 horizon $out/bin/horizon

    runHook postInstall
  '';

  meta = {
    description = "GPU-accelerated terminal board that puts all your sessions on an infinite canvas";
    homepage = "https://github.com/peters/horizon";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "horizon";
  };
}
