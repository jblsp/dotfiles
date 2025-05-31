{...}: {
  programs.go = {
    enable = true;
    goPath = ".local/share/go";
    telemetry.mode = "local";
  };
}
