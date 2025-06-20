{...}: {
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      strategy = ["completion"];
    };

    enableCompletion = true;

    shellAliases = {
      sudo = "sudo ";
      ff = "fastfetch";
    };

    syntaxHighlighting = {
      enable = true;
    };
  };
}
