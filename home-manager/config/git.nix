{
  pkgs,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Joe";
    userEmail = "48526917+jblsp@users.noreply.github.com";
    ignores = [
      ".DS_Store"
      "*.swp"
    ];
    aliases = {
      "root" = "rev-parse --show-toplevel";
    };
    signing = {
      signByDefault = true;
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQFryUkLgK9rtC15uPGxqER/K6FkiLLlDZoI0RAWtVg";
    };
    extraConfig = {
      init.defaultBranch = "main";
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      diff.renames = true;
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}.config/git/allowedSigners";
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
    };
    diff-so-fancy.enable = true;
  };
  home.file.".config/git/allowedSigners" = {
    force = true;
    text = let
      allowedSigners = {
        "48526917+jblsp@users.noreply.github.com" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQFryUkLgK9rtC15uPGxqER/K6FkiLLlDZoI0RAWtVg";
      };
    in
      builtins.concatStringsSep "\n" (
        builtins.map
        (key: "${key} ${toString allowedSigners.${key}}")
        (builtins.attrNames allowedSigners)
      );
  };
}
