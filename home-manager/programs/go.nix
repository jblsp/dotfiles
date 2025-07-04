{config, ...}: {
  programs.go = {
    enable = true;
    goPath = ".local/share/go";
    telemetry.mode = "local";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/${config.programs.go.goPath}/bin"
  ];
}
