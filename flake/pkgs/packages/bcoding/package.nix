{
  lib,
  python311Packages,
  fetchPypi
}:
python311Packages.buildPythonPackage rec {
  pname = "bcoding";
  version = "1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S7ihC1GjbwhA6jQa4JWMPhqD7ExMsrBZ6Ja1b/6E4nA=";
  };
  build-system = [ python311Packages.setuptools ];
}
