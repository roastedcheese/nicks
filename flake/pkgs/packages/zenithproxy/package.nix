{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  gradle_9,
  jdk25,
  git,
  jre,
  jvmArgs ? ["-XX:+UseG1GC" "-XX:+UnlockExperimentalVMOptions" "-XX:+PerfDisableSharedMem" "-XX:+UseCompactObjectHeaders" "--sun-misc-unsafe-memory-access=allow" "--enable-native-access=ALL-UNNAMED" "--Xmx300M"],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zenithproxy";
  version = "3.2.0+linux.1.21.4";

  src = fetchFromGitHub {
    owner = "rfresh2";
    repo = "zenithproxy";
    rev = "b4f837749c6ac9e5a3b33d2a0e42f154c41e6ee4";
    hash = "sha256-Kv7xHEBuHFGvAlUOWC0vKzQNZRgQ9OEDMWeSFHcQ+gE=";
  };

  # Configuration cache breaks the deps script
  patches = [./gradle.patch];

  nativeBuildInputs = [
    (gradle_9.override {
      javaToolchains = [jdk25];
    })
    git
    makeWrapper
  ];

  gradleTasks = ["build"];

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  doCheck = true;

  installPhase = ''
    mkdir -p $out/{bin,share/zenithproxy}
    cp build/libs/ZenithProxy.jar $out/share/zenithproxy

    makeWrapper ${lib.getExe jre} $out/bin/zenithproxy \
      --add-flags "-jar $out/share/zenithproxy/ZenithProxy.jar ${lib.strings.concatStringsSep " " jvmArgs}"
  '';
})
