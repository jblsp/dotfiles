{
  config,
  lib,
  ...
}: {
  programs.go = {
    goPath = ".local/share/go";
    telemetry.mode = "local";
  };

  home.sessionPath = lib.mkIf config.programs.go.enable [
    "${config.home.homeDirectory}/${config.programs.go.goPath}/bin"
  ];
}
