{
  python3Packages,
  fetchPypi,
  fetchpatch,
}:
python3Packages.buildPythonPackage rec {
  pname = "heybrochecklog";
  version = "1.3.2";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VZsYlNtWEFNwwWZqpYH6A2zll8ZAXDQ8WB8due1YDps=";
  };

  patches = [./build.patch];
  nativeBuildInputs = let
    # :P
    chardet = python3Packages.buildPythonPackage rec {
      pname = "chardet";
      version = "3.0.4";

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-hKuS7RxNTxaRbgWQa2t1psD7XbghzGXnDL1ko+Kl6q4=";
      };

      patches = [
        # Add pytest 4 support. See: https://github.com/chardet/chardet/pull/174
        (fetchpatch {
          url = "https://github.com/chardet/chardet/commit/0561ddcedcd12ea1f98b7ddedb93686ed8a5ffa4.patch";
          sha256 = "sha256-WNjctETskgvNRZZh4QQfjqSzOXwXle90wrBlMZyEPfg=";
        })
      ];

      checkInputs = with python3Packages; [pytest pytestrunner hypothesis];
    };
  in [python3Packages.poetry-core chardet];
  nativeCheckInputs = [python3Packages.pytest];
}
