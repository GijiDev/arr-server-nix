{ pkgs, ... }:
let
  inherit (pkgs)
    lib
    fetchFromGitHub
    fetchPypi
    python313
    ;

  packageOverrides = self: super: {
    iso8601 = super.iso8601.overridePythonAttrs (oldAttrs: rec {
      version = "1.1.0";
      src = fetchPypi {
        inherit version;
        inherit (oldAttrs) pname;
        hash = "sha256-MoEee4He7iBj6m0ulPiBmobR84EeSdI2I6QfqDK+8D8=";
      };
    });

    urllib3 = super.urllib3.overridePythonAttrs (oldAttrs: rec {
      version = "1.26.20";
      src = fetchPypi {
        inherit version;
        inherit (oldAttrs) pname;
        hash = "sha256-QMLcDGgeR+uPkOfie/b/ffLmd0If1GdW2hFhw5ynDTI=";
      };
    });
  };

  python = python313.override {
    inherit packageOverrides;
  };

in
python.pkgs.buildPythonApplication rec {
  pname = "nhentai";
  version = "0.6.0-beta";

  src = fetchFromGitHub {
    owner = "RicterZ";
    repo = "nhentai";
    rev = version;
    hash = "sha256-NIorZ5ZxoPzTfvMCM2oAE0uiPFya4L/Anacoy9D/79U=";
  };

  # tests require a network connection
  doCheck = false;

  pyproject = true;
  build-system = [
    python.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python.pkgs; [
    requests
    soupsieve
    beautifulsoup4
    tabulate
    iso8601
    urllib3
    httpx
    chardet
  ];

  meta = {
    homepage = "https://github.com/RicterZ/nhentai";
    description = "CLI tool for downloading doujinshi from adult site(s)";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nhentai";
  };
}
