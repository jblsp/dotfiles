{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.go.enable {
    programs.go = {
      goPath = ".local/share/go";
      telemetry.mode = "local";
    };
    home.sessionPath = [
      "${config.home.homeDirectory}/${config.programs.go.goPath}/bin"
    ];
  };
}
