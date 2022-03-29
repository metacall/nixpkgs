{lib, stdenv, fetchFromGitHub, cmake, extra-cmake-modules, git, rapidjson, makeWrapper,
withPy, withNode, withTypescript, withC, withRuby, withJava, withCobalt}:

stdenv.mkDerivation rec {
  pname = "metacall";
  version = "0.5.7";
  #hardeningDisable = [ "all" ];
  cmakeFlags = [ "-Wno-dev" "-DOPTION_BUILD_DETOURS=off" "-DOPTION_FORK_SAFE=off" "-DOPTION_BUILD_TESTS=off"];
  NIX_CFLAGS_COMPILE = ["-Wno-error" ]; # "-Wno-stringop-truncation" "-Wno-dev" "-Wno-stringop-overread" "-Wno-stringop-overflow"];
  src = fetchFromGitHub {
    owner = "metacall";
    repo = "core";
    rev = "adcc50496d53797011b87f42131cb857d0009ffb";
    sha256 = "13cfyswmjbdbwl17qb639mdd0x2vm1k96kmkh4bs3fzhvbrw43r5";
  };
  # Support for loaders disabled by default
  # Unless user pkg overrides
  withNode = false;
  withJS = false;
  withCobalt = false;
  withPy = false;
  withJava = false;
  withRuby = false;
  withC = false;
  withTypescript = false;

  buildInputs = [ cmake extra-cmake-modules git rapidjson ];
  nativeBuildInputs = [ makeWrapper ];
  # TODO: List all needed dependencies for each loaders support
  #buildInputs = lib.optionals withTypescript [ nixpkgs.nodePackages.typescript ] 
  #++ lib.optionals withPy [ nixpkgs.python3Full ]
  #++ lib.optionals withNode [ nixpkgs.nodejs ]
  ##++ lib.optionals withJS [ nixpkgs.nodejs ];
 # ++ lib.optionals withC []
 # ++ lib.optionals withRuby []
 # ++ lib.optionals withJava []
 # ++ lib.optionals withCobalt [];
  # TODO: Add optionals CmakeFlags
  doCheck = true;
  
  postInstall = ''
        makeWrapper $out/metacallcli $out/metacall \
      --prefix LOADER_LIBRARY_PATH : "$out/lib/" \
      --prefix SERIAL_LIBRARY_PATH : "$out/lib" \
      --prefix DETOUR_LIBRARY_PATH : "$out/lib" \
      --prefix PORT_LIBRARY_PATH : "$out/lib" \
      --prefix CONFIGURATION_PATH: "$out/configurations/globals.json" \
  '';
  #--prefix PYTHONPATH : "${lib.makeLibraryPath libraries}" \
  meta = with lib; {
    description = "A CLI for the library providing inter-language foreign function interface calls";
    homepage = "https://metacall.io/";
    changelog = "https://github.com/metacall/core/releases/tag/v${version}";
    license = licenses.asl20; # Apache 2.0
    maintainers = with maintainers; [ akechishiro ]; 
    platforms = platforms.linux;
    mainProgram = "metacall";
  };
}
