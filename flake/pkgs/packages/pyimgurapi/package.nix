{
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "pyimgurapi";
  version = "0.4.3";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c8Vf/bnf6wyiI0OGvMS3Or7CPZK6ruK2mg5PzQqNcgI=";
  };

  nativeBuildInputs = [ python3Packages.poetry-core ];
}
