{
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "bcoding";
  version = "1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S7ihC1GjbwhA6jQa4JWMPhqD7ExMsrBZ6Ja1b/6E4nA=";
  };
  build-system = [python3Packages.setuptools];
}
