{ ... }:

{

  programs = {
    zsh = {
      initExtra = "pfetch";
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      envExtra = ''
        export XDG_DATA_HOME="$HOME/.local/share"
        export LC_CTYPE=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
      '';
      oh-my-zsh = {
        enable = true;
        theme = "lambda";
        plugins = [ "sudo" "git" "npm" "ng" "web-search" "systemd"];
      };
      shellAliases = {
        "ll" = "ls -l";
        ".." = "cd ..";
        "update" = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#";
        "config" = "ranger ~/nixos-config";
      };
    };
  };
}
