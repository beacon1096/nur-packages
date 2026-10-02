{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "1.5.1";

  sources = {
    x86_64-linux = {
      url = "https://dl.lazycatmicroserver.com/hclient-cli/v${version}/hclient-cli-linux-amd64";
      hash = "sha256-oM3ry2Ur2uS6Jv+WgnxVjzaK8Gc62RBUW0SZ+Yl8+mw=";
    };
    aarch64-linux = {
      url = "https://dl.lazycatmicroserver.com/hclient-cli/v${version}/hclient-cli-linux-arm64";
      hash = "sha256-NIxVyHpMNF6pwFkeujCOeyhrNAllQ7Hkfk4kV8WDLt4=";
    };
    riscv64-linux = {
      url = "https://dl.lazycatmicroserver.com/hclient-cli/v${version}/hclient-cli-linux-riscv64";
      hash = "sha256-Mq9E8q3amkzGlnFqZRLxdvY+YnNH8ZGOjsh27kz1VAQ=";
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
