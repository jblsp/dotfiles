{...}: {
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = ["https://github.com" "https://github.example.com"];
    };
  };
}
