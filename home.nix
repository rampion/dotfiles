{ config, pkgs, ... }:

with import <nixpkgs> { };

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rampion";
  home.homeDirectory = "/home/rampion";

  # nix doesn't install packages with an unfree license (like zoom-us)
  # unless told to
  nixpkgs.config.allowUnfree = true;

  # Packages to install
  home.packages = [
    # pkgs is the set of all packages in the default home.nix
    # implementation
    pkgs.git
    #pkgs.vim_configurable # used over pkgs.vim for +clipboard support
    pkgs.zoom-us
    pkgs.slack
    pkgs.todoist-electron
    pkgs.tailscale # used to connect to Mercury's VPN
    pkgs.spotify
    pkgs.tree

    pkgs.ghc
    pkgs.cabal-install
    pkgs.ghcid

    pkgs.fzf
    pkgs.gnumake
  ];

  # application-specific configuration
  dconf.settings = {
    # Make the Caps Lock key act like Esc
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape" ];
    };
  };

  # Raw configuration files
  home.file.".gitconfig".source = ./gitconfig;
  home.file.".gitexcludes".source = ./gitexcludes;
  home.file.".vim/plugin/statusline.vim".source = ./vim/plugin/statusline.vim;

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./vimrc;

    plugins =
      let yesod-routes = pkgs.vimUtils.buildVimPlugin {
          name = "yesod-routes";
          src = pkgs.fetchFromGitHub {
            owner = "5outh";
            repo = "yesod-routes.vim";
            rev = "e00eaafe22aa33e2cf4a67d83dad4bc8ccdebbc5";
            sha256 = "1vPLDlMrzZErdAzmWTAFHvrqtRDo0W0OehHf1nGaVd0=";
          };
        };
      in
    [
      # browse available plugins via `nix-env -f '<nixpkgs>' -qaP -A vimPlugins`
      pkgs.vimPlugins.ale
      #pkgs.vimPlugins.coc-nvim
      pkgs.vimPlugins.fzf-vim
      pkgs.vimPlugins.gruvbox
      pkgs.vimPlugins.gv-vim # git commit visualizer
      pkgs.vimPlugins.haskell-vim
      pkgs.vimPlugins.syntastic
      pkgs.vimPlugins.unicode-vim
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-nix # nix highlighting
      pkgs.vimPlugins.vim-plugin-AnsiEsc
      pkgs.vimPlugins.vim-rhubarb # github integration
      pkgs.vimPlugins.vim-signify # inline git diffs
      pkgs.vimPlugins.vimwiki
      yesod-routes
    ];
  };

  home.file.".config/zsh/env/jq.zsh".source = ./zsh/env/jq.zsh;
  home.file.".config/zsh/env/less.zsh".source = ./zsh/env/less.zsh;
  home.file.".config/zsh/env/ls.zsh".source = ./zsh/env/ls.zsh;
  home.file.".config/zsh/env/man.zsh".source = ./zsh/env/man.zsh;
  home.file.".config/zsh/env/mvn.zsh".source = ./zsh/env/mvn.zsh;
  home.file.".config/zsh/env/options.zsh".source = ./zsh/env/options.zsh;
  home.file.".config/zsh/env/python.zsh".source = ./zsh/env/python.zsh;
  home.file.".config/zsh/env/vim.zsh".source = ./zsh/env/vim.zsh;
  home.file.".config/zsh/rc/git-completion.zsh".source = ./zsh/rc/git-completion.zsh;
  home.file.".config/zsh/rc/history.zsh".source = ./zsh/rc/history.zsh;
  home.file.".config/zsh/rc/options.zsh".source = ./zsh/rc/options.zsh;
  home.file.".config/zsh/rc/prompt.zsh".source = ./zsh/rc/prompt.zsh;
  home.file.".config/zsh/rc/term/xterm-256color.zsh".source = ./zsh/rc/term/xterm-256color.zsh;
  home.file.".config/zsh/rc/time.zsh".source = ./zsh/rc/time.zsh;

  programs.zsh = {
    enable = true;
    sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock";
    };

    dotDir = ".config/zsh";

    envExtra = builtins.readFile ./zsh/env.zsh;
    initExtra = builtins.readFile ./zsh/rc.zsh;
    loginExtra = builtins.readFile ./zsh/login.zsh;
    logoutExtra = builtins.readFile ./zsh/logout.zsh;
    profileExtra = builtins.readFile ./zsh/profile.zsh;
  };

}
