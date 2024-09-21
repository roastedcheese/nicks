{
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "packaging";
  version = "20.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WzJ6wTINyGPcpy9FFOzAhvMRhnRLhKIwN0zB/Xdv6uU=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = with python3Packages; [pyparsing six wheel];

  checkInputs = with python3Packages; [
    pytestCheckHook
    pretend
  ];

  # Prevent circular dependency
  doCheck = false;
}
