{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "1.5.8";

  sources = {
    x86_64-linux = {
      url = "https://dl.lazycatmicroserver.com/hclient-cli/v${version}/hclient-cli-linux-amd64";
      hash = "sha256-NDpuQxUucPT0I0ksiiBeCssN51rzh2BqhN8yBRZ0lE0=";
    };
    aarch64-linux = {
      url = "https://dl.lazycatmicroserver.com/hclient-cli/v${version}/hclient-cli-linux-arm64";
      hash = "sha256-gB8hu22CuUyZ0mUZw6T6qCut0HMbwPvowUEbltfHjg4=";
    };
    riscv64-linux = {
      url = "https://dl.lazycatmicroserver.com/hclient-cli/v${version}/hclient-cli-linux-riscv64";
      hash = "sha256-335BxGzb1/kbEAqBiIIFi1PMVszgN4jXHdWcMoLghbY=";
    };
  };

  source = sources.${stdenv.hostPlatform.system} or null;
in
stdenv.mkDerivation {
  pname = "hclient-cli";
  inherit version;

  src = if source == null then null else fetchurl { inherit (source) url hash; };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/hclient-cli"

    runHook postInstall
  '';

  meta = {
    description = "Lazycat Microserver CLI client (懒猫微服命令行客户端)";
    homepage = "https://lazycat.cloud/download";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "riscv64-linux"
    ];
    mainProgram = "hclient-cli";
  };
}
