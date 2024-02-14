{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreSpace = true;
      ignorePatterns = [ "*/docs/*"];
      save = 1000;
      path = "${config.xdg.dataHome}/zsh_history";
    };

    initExtra = ''
      # If you come from bash you might have to change your $PATH.
      export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

      # Set list of themes to pick from when loading at random
      # Setting this variable when ZSH_THEME=random will cause zsh to load
      # a theme from this variable instead of looking in $ZSH/themes/
      # If set to an empty array, this variable will have no effect.
      # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

      # Uncomment the following line to use case-sensitive completion.
      # CASE_SENSITIVE="true"

      # Uncomment the following line to use hyphen-insensitive completion.
      # Case-sensitive completion must be off. _ and - will be interchangeable.
      # HYPHEN_INSENSITIVE="true"

      # Uncomment one of the following lines to change the auto-update behavior
      # zstyle ':omz:update' mode disabled  # disable automatic updates
      # zstyle ':omz:update' mode auto      # update automatically without asking
      zstyle ':omz:update' mode disabled # just remind me to update when it's time

      # Uncomment the following line if pasting URLs and other text is messed up.
      DISABLE_MAGIC_FUNCTIONS="true"

      # Uncomment the following line to disable auto-setting terminal title.
      DISABLE_AUTO_TITLE="true"

      # Uncomment the following line if you want to disable marking untracked files
      # under VCS as dirty. This makes repository status check for large repositories
      # much, much faster.
      # DISABLE_UNTRACKED_FILES_DIRTY="true"

      # Uncomment the following line if you want to change the command execution time
      # stamp shown in the history command output.
      # You can set one of the optional three formats:
      # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
      # or set a custom format using the strftime function format specifications,
      # see 'man strftime' for details.
      HIST_STAMPS="dd/mm/yyyy"

      # User configuration

      # export MANPATH="/usr/local/man:$MANPATH"

      # You may need to manually set your language environment
      export LANG=en_US.UTF-8

      # Preferred editor for local and remote sessions
      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='vim'
      else
        export EDITOR='nvim'
      fi

      set -o vi

      # Settings stolen from professional schizophrenic @lukesmithxyz

      # Use neovim for vim if present.
      [ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"

      # Verbosity and settings that you pretty much just always are going to want.
      alias \
        mv="mv -iv" \
          cp="cp -riv" \
        rm="rm -vI" \
        bc="bc -ql" \
        mkd="mkdir -pv" \
        yt="youtube-dl --add-metadata -i" \
        yta="yt -x -f bestaudio/best" \
        po="poweroff"\
        rb="reboot"\
        ffmpeg="ffmpeg -hide_banner"\
        irssi="irssi --home=$XDG_CONFIG_HOME/irssi"\
        lf="lfub"\
        rebuild="nixos-rebuild switch --use-remote-sudo --flake $HOME/nicks --show-trace"\
        hm="home-manager switch --flake . -b backup"\
        update="nix flake update; npins upgrade"


      # Colorize commands when possible.
      alias \
        ls="ls -hN --color=auto --group-directories-first" \
        grep="grep --color=auto" \
        diff="diff --color=auto" \
        ccat="highlight --out-format=ansi"

      # These common commands are just too long! Abbreviate them.
      alias \
        ka="killall" \
        g="git" \
        e="$EDITOR" \
        v="$EDITOR" \
        xi="sudo xbps-install" \
        xr="sudo xbps-remove -R" \
        xq="xbps-query" \
        sctl="systemctl"\
        search="nix search"
    '';
  };
}
