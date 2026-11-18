{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkg-config,
  cmake,
  openssl,
  onnxruntime,
}:

rustPlatform.buildRustPackage rec {
  pname = "octocode";
  version = "0.29.2";

  src = fetchFromGitHub {
    owner = "Muvon";
    repo = "octocode";
    tag = version;
    hash = "sha256-HhMrESfni7mUjySeuRQm4Zmfg/Op8sCWWoGMSmAeWUQ=";
  };

  nativeBuildInputs = [
    protobuf
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
    onnxruntime
  ];

  buildFeatures = [ "fastembed" "huggingface" ];

  cargoHash = "sha256-i620acS+UyAir2pgXVaBKoZACyrmASuHc5u3HNGyFJ0=";

  env = {
    PROTOC = "${protobuf}/bin/protoc";
    ORT_LIB_LOCATION = "${onnxruntime}/lib";
    ORT_PREFER_DYNAMIC_LINK = "1";
  };

  # Tests require network access and API keys
  doCheck = false;

  meta = {
    description = "AI-powered code intelligence with semantic search, knowledge graphs, and MCP server";
    homepage = "https://github.com/Muvon/octocode";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "octocode";
  };
}
