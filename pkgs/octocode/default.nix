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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Muvon";
    repo = "octocode";
    tag = version;
    hash = "sha256-nyEdkrkaLcqePyOlQQ1n1rlH/CrjTUIEEhzELV9u80U=";
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

  cargoHash = "sha256-zz5Woz1VrWudy3NmTKld+lo/417J/xbqKnrOPdfHhyo=";

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
