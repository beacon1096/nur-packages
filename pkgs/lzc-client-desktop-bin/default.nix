{
  lib,
  stdenv,
  fetchurl,
  zstd,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libcap,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  udev,
  util-linux,
  xdg-utils,
  xorg,
  zenity,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lzc-client-desktop";
  version = "2.0.11";

  src = fetchurl {
    url = "https://dl.lazycat.cloud/client/desktop/stable/lzc-client-desktop_v${finalAttrs.version}.tar.zst";
    hash = "sha256-EFnVqkKWr0L8xovoEVGFAQ/Vj2nuwpfDn9f3S3k6nBc=";
  };

  # The archive unpacks straight into the build directory instead of a
  # single top-level directory.
  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    zstd
  ];

  # The bundled node_modules contain musl prebuilds of sharp/libvips next to the
  # glibc ones; only the glibc variants are used at runtime.
  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libcap
    libxkbcommon
    mesa
    nspr
    nss
    pango
    udev
    util-linux
    xdg-utils
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
  ];

  installPhase = ''
    runHook preInstall

    appdir="$out/lib/lzc-client-desktop"
    mkdir -p "$appdir"
    cp -a . "$appdir/"
    chmod -R u+w "$appdir"

    # chrome-sandbox cannot be installed setuid-root from the read-only Nix
    # store, so the namespace sandbox is used instead. Where unprivileged user
    # namespaces are unavailable (e.g. hardened kernels, AppArmor confinements)
    # there is no usable sandbox left and Electron refuses to start unless the
    # sandbox is disabled explicitly.
    makeWrapper "$appdir/lzc-client-desktop" "$out/bin/lzc-client-desktop" \
      --prefix PATH : "${lib.makeBinPath [ libcap util-linux xdg-utils zenity ]}" \
      --run 'if unshare --user --map-root-user true 2>/dev/null; then
               set -- --disable-setuid-sandbox "$@"
             else
               set -- --no-sandbox "$@"
             fi'

    substituteInPlace "$appdir/lzc-client.desktop" \
      --replace-fail 'Exec=HOMEDIR/.local/share/lzc-client-desktop/lzc-client-desktop' "Exec=$out/bin/lzc-client-desktop" \
      --replace-fail 'Icon=HOMEDIR/.local/share/lzc-client-desktop/icon.png' 'Icon=lzc-client-desktop'
    install -Dm644 "$appdir/lzc-client.desktop" "$out/share/applications/lzc-client-desktop.desktop"

    install -Dm644 "$appdir/icon.png" "$out/share/icons/hicolor/512x512/apps/lzc-client-desktop.png"
    install -Dm644 "$appdir/icon.png" "$out/share/pixmaps/lzc-client-desktop.png"

    # The application looks for its window/tray icon next to app.asar.
    mkdir -p "$appdir/resources"
    ln -s ../icon.png "$appdir/resources/icon.png"

    # The policy keeps upstream's `__SETCAP_SCRIPT_PATH__` placeholder, which
    # the application substitutes itself once it installs the setcap helper.
    install -Dm644 "$appdir/cloud.lazycat.client.policy" \
      "$out/share/polkit-1/actions/cloud.lazycat.client.policy"

    # These are installed into the XDG directories above.
    rm -f "$appdir/lzc-client.desktop" "$appdir/cloud.lazycat.client.policy"

    runHook postInstall
  '';

  meta = {
    description = "Lazy Cat microservice desktop client";
    longDescription = ''
      Lazy Cat (懒猫微服) desktop client for connecting to a Lazy Cat
      microserver. The upstream package is distributed as a prebuilt Electron
      application.

      The bundled chrome-sandbox helper cannot be installed setuid-root from the
      read-only Nix store, so the wrapper falls back to the Electron user
      namespace sandbox and, on systems where unprivileged user namespaces are
      unavailable, to --no-sandbox. The polkit action that grants the bundled
      lzc-core binary CAP_NET_ADMIN calls setcap on files in the store, so
      capability-based network features need additional local setup.
    '';
    homepage = "https://lazycat.cloud/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lzc-client-desktop";
  };
})
