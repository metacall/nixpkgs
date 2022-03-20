{lib, stdenv, fetchurl, cmake,
withPy, withNode, withTypescript, withC, withRuby, withJava, withCobalt}:

stdenv.mkDerivation rec {
  pname = "metacall-cli";
  version = "0.5.7";

  src = fetchurl {
    url = "https://github.com/metacall/core/archive/v${version}.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
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

  nativebuildInputs = [ cmake ];
  # TODO: List all needed dependencies for each loaders support
  buildInputs = lib.optionals withTypescript [ nodePackages.typescript ] 
  ++ lib.optionals withPy [ python3Full ]
  ++ lib.optionals withNode [ nodejs ]
  ++ lib.optionals withJS []
  ++ lib.optionals withC []
  ++ lib.optionals withRuby []
  ++ lib.optionals withJava []
  ++ lib.optionals withCobalt [];
  # TODO: Add optionals CmakeFlags
  doCheck = true; # Run cmake tests


  meta = with lib; {
    description = "A CLI for the library providing inter-language foreign function interface calls";
    homepage = "https://metacall.io/";
    changelog = "https://github.com/metacall/core/releases/tag/v${version}";
    license = licenses.asl20; # Apache 2.0
    maintainers = with maintainers; [ akechishiro ]; 
    platforms = platforms.all;
  };
}

