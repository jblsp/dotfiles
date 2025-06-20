{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "joe";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${config.home.username}/"
      else "/home/${config.home.username}/";
    sessionPath = [
      "${config.home.homeDirectory}.local/bin"
    ];
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      SSH_AUTH_SOCK = "${config.home.homeDirectory}.bitwarden-ssh-agent.sock";
    };
    stateVersion = "24.11";
  };
}
