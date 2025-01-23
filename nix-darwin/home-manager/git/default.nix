{...}: {
  programs.git = {
    enable = true;
    userName = "Joe";
    userEmail = "48526917+jblsp@users.noreply.github.com";
    ignores = [
      ".DS_Store"
      "*.swp"
    ];
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
