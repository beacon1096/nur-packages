{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "dimagent";
  version = "0.5.2";

  src = fetchurl {
    url = "https://dimcode.echooai.com/updates/stable/linux/x64/DimAgent-${version}.AppImage";
    hash = "sha256-U5Ytonjge0JzrZrS5NtImVIkNx0VoA1OxXfynX7f/Z4=";
  };

  meta = {
    description = "Native desktop app for visual coding workspaces";
    homepage = "https://dimcode.dev/";
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "dimagent";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
