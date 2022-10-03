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

    # 
    pkgs.zoom-us
    pkgs.slack
    pkgs.todoist-electron
    pkgs.spotify

    pkgs.ghc
    pkgs.cabal-install
    pkgs.ghcid
    pkgs.cabal2nix
    pkgs.haskell-language-server

    # vim installed by programs.vim below
    pkgs.git
    pkgs.tree
    pkgs.fzf
    pkgs.gnumake
    pkgs.zip
    pkgs.unzip
    pkgs.tailscale # used to connect to Mercury's VPN
    pkgs.qpdf
    pkgs.imagemagickBig
    pkgs.jq

    pkgs.any-nix-shell
    pkgs.direnv

    # required for coc.nvim
    pkgs.nodejs
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
  home.file.".ssh/config".source = ./ssh-config;

  home.file.".vim/plugin/statusline.vim".source = ./vim/plugin/statusline.vim;
  home.file.".vim/after/ftplugin/markdown.vim".source = ./vim/after/ftplugin/markdown.vim;
  home.file.".vim/coc-settings.json".source = ./vim/coc-settings.json;

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./vimrc;

    plugins =
      let
        yesod-routes = pkgs.vimUtils.buildVimPlugin {
          name = "yesod-routes";
          src = pkgs.fetchFromGitHub {
            owner = "5outh";
            repo = "yesod-routes.vim";
            rev = "e00eaafe22aa33e2cf4a67d83dad4bc8ccdebbc5";
            sha256 = "1vPLDlMrzZErdAzmWTAFHvrqtRDo0W0OehHf1nGaVd0=";
          };
        };
        syntax-shakespeare = pkgs.vimUtils.buildVimPlugin {
          name = "vim-syntax-shakespeare";
          src = pkgs.fetchFromGitHub {
            owner = "pbrisbin";
            repo = "vim-syntax-shakespeare";
            rev = "2f4f61eae55b8f1319ce3a086baf9b5ab57743f3";
            sha256 = "sdCXJOvB+vJE0ir+qsT/u1cHNxrksMnqeQi4D/Vg6UA=";
          };
        };
        coc-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "coc.nvim";
          version = "2022-05-21";
          src = pkgs.fetchFromGitHub {
            owner = "neoclide";
            repo = "coc.nvim";
            rev = "791c9f673b882768486450e73d8bda10e391401d";
            sha256 = "sha256-MobgwhFQ1Ld7pFknsurSFAsN5v+vGbEFojTAYD/kI9c=";
          };
          meta.homepage = "https://github.com/neoclide/coc.nvim/";
        };
      in
    [
      # browse available plugins via `nix-env -f '<nixpkgs>' -qaP -A vimPlugins`
      pkgs.vimPlugins.ale

      # bug with current version of coc-nvim in nixpkgs
      # https://github.com/nix-community/home-manager/issues/2966
      #pkgs.vimPlugins.coc-nvim
      coc-nvim

      pkgs.vimPlugins.direnv-vim
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
      syntax-shakespeare
    ];
  };

  home.file.".config/zsh/env/direnv.zsh".source = ./zsh/env/direnv.zsh;
  home.file.".config/zsh/env/jq.zsh".source = ./zsh/env/jq.zsh;
  home.file.".config/zsh/env/less.zsh".source = ./zsh/env/less.zsh;
  home.file.".config/zsh/env/ls.zsh".source = ./zsh/env/ls.zsh;
  home.file.".config/zsh/env/man.zsh".source = ./zsh/env/man.zsh;
  home.file.".config/zsh/env/mvn.zsh".source = ./zsh/env/mvn.zsh;
  home.file.".config/zsh/env/nix.zsh".source = ./zsh/env/nix.zsh;
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

  # run by nix-shell
  programs.bash = {
    enable = true;
    initExtra = ''
      # use vi keybindings on the command line
      set -o vi
    '';
  };
}
