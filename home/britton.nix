{ config, pkgs, lib, unstablePkgs, ... }:
{
  home.stateVersion = "23.05";

  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "b@robitzs.ch";
    userName = "Britton Robitzsch";
    delta.enable = true;
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.tmux = {
    enable = true;
    #keyMode = "vi";
    clock24 = true;
    historyLimit = 10000;
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
    ];
    extraConfig = ''
      new-session -s main
      bind-key -n C-a send-prefix
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    #initExtra = (builtins.readFile ../mac-dot-zshrc);
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
  theme = "base16_default_dark";
  editor.lsp.display-messages = true;
  keys.normal = {
    space.space = "file_picker";
    space.w = ":w";
    space.q = ":q";
  };
  };
  };

  programs.eza.enable = true;
  programs.eza.enableAliases = true;
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.nix-index.enable = true;
  programs.zoxide.enable = true;
  programs.yazi.enable =  true;
  programs.yazi.enableZshIntegration = true;
  home.file.yabai = {
    executable = true;
    target = ".config/yabai/yabairc";
    text = ''
      #!/usr/bin/env sh
      # load scripting addition
      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      yabai -m config layout bsp
      yabai -m config auto_balance on
      yabai -m config window_topmost on
      yabai -m config top_padding    10
      yabai -m config bottom_padding 10
      yabai -m config left_padding   10
      yabai -m config right_padding  10
      yabai -m config window_gap     10
      # rules
      yabai -m rule --add app="^System Preferences$" manage=off
      echo "yabai configuration loaded.."
    '';
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
    Host *
      StrictHostKeyChecking no
    '';
    matchBlocks = {
      # wd
      "m morpheus" = {
        hostname = "10.42.1.10";
        user = "alex"; };
      "a anton" = {
        hostname = "10.42.1.20";
        user = "root";
      };
      "bricktop" = {
        hostname = "10.42.1.80";
        user = "pi";
      };
      "z zoidberg" = {
        hostname = "10.42.1.42";
        user = "root";
      };
      "m1" = {
        hostname = "10.42.1.30";
        user = "root";
      };
    };
  };


}
