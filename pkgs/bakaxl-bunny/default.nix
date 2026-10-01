{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  cairo,
  dbus,
  dpkg,
  gdk-pixbuf,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  gtk3,
  hicolor-icon-theme,
  libsoup_3,
  openssl,
  pango,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:

let
  releaseVersion = "4.0.0+bunny-aac68df";
in
stdenv.mkDerivation {
  pname = "bakaxl-bunny";
  version = "4.0.0.bunny_aac68df";

  src = fetchurl {
    url = "https://github.com/BakaXL-Launcher/BakaXL/releases/download/${releaseVersion}/bakaxl-${releaseVersion}-linux-x86_64.deb";
    hash = "sha256-/rgDyxM8R/rmWmSUx/nqeWkpW9/vgMJwM/DZMKxMVBE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk3
    hicolor-icon-theme
    libsoup_3
    openssl
    pango
    stdenv.cc.cc.lib
    webkitgtk_4_1
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    dpkg-deb -x "$src" "$out"

    mkdir -p "$out/bin"
    mv "$out/usr/bin/BakaXL" "$out/bin/BakaXL"
    mv "$out/usr/share" "$out/share"
    rmdir "$out/usr/bin" "$out/usr"

    runHook postInstall
  '';

  meta = {
    description = "Next Generation BakaXL Minecraft launcher";
    homepage = "https://bakaxl.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "BakaXL";
  };
}
