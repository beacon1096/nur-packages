{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
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

  # ethnum 1.5.2 does not compile with rustc >= 1.97 because TryFromIntError is
  # no longer a zero-sized type. Keep the pinned version and apply the upstream
  # source fix to the vendored crate.
  postPatch = ''
    shopt -s nullglob
    for crate in "$cargoDepsCopy"/source-registry-*/ethnum-1.5.2; do
      patch -p1 -d "$crate" < ${
        fetchpatch2 {
          name = "ethnum-1.5.2-rustc-1.97.patch";
          url = "https://github.com/nlordell/ethnum-rs/commit/87e3457c095c98fcac554548ee80f56e0cfb80ae.patch?full_index=1";
          hash = "sha256-xG3RQg2vF+XW9IiYWaNyOF39WipSeoZGrygsOJ3XgIs=";
        }
      }
    done
  '';

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
