{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      <nixos-hardware/raspberry-pi/4>
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = "pltc-infoscreen";
    extraHosts = "107.189.30.63 nixvps";
  };

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  hardware ={
    raspberry-pi."4" = {
      fkms-3d.enable = true;
      apply-overlays-dtmerge.enable = true;
    };
  };

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    allowedUsers = [ "@wheel" "infoscreen"];
  };

  security = {
    sudo.execWheelOnly = true;
    sudo.wheelNeedsPassword = false;
  };

  services = {
    autossh = {
      sessions = [
        { extraArguments = "-N -R 9743:localhost:22 autossh@nixvps";
          monitoringPort = 0;
          name = "infoscreen";
          user = "autossh";
        }
      ];
    };

    xserver = {
      enable = true;
      #desktopManager.xfce.enable = true;
      displayManager = {
        defaultSession = "infoscreen";
        session = [
          { manage = "desktop";
            name = "infoscreen";
            start = ''exec $HOME/.xsession'';
          }
        ];
        autoLogin = {
          enable = true;
          user = "infoscreen";
        };
        lightdm = {
          enable = true;
        };
      };
    };

    openssh = {
      enable = true;
      challengeResponseAuthentication = false;
      passwordAuthentication = false;
      extraConfig = ''
        StreamLocalBindUnlink yes
        ClientAliveInterval 20
        ClientAliveCountMax 6
        TCPKeepAlive yes
      '';
    };

  };

  users = {
    users =  {
      zfnmxt = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCjD7Vt+qzI3ubh0GBM32QeC8kpi8z9B4RhFH+o3RZvaGOZNU16tvrg/iIk8JtGl9eCOKlpksRgoTIloC83oJZAAcy9TdNMtzdC/VHP/BeCIX3c8a5Qg3WTDGlib2AWf9O61T2qX84dE60rWEqHhJ5LWws3tVG1Gd9j2Vz7uNExJnuWkn9mZ0l+VvLBhYnIp3Db4ZTSpKPFHWJr2tsDWVmYS/5loZBL+rqOuG7xa48Ltlfb8rHkrCkx3HcObHYjH7sMB0g2zKEidFvJL7FxkWP5XiK4XBk0UuhPzvmewNz6wBcJnEKmtBiYmMftmkZrgwwSDi2/VhDgeL8Ez9opwJn"
        ];
      };
      athas = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA4FAeTJKuTHjKnr2ReiaJDbBxwdTYH6M7FWTzWv0MEXsfpny9Sf0HuDOYjVFxw0kLrdlGG+HwYT1j7ReZHhTYN0cRmYsyA12iVZl3nEvdZAB1b+O7KCnJ0dXnWGRJYJQ5GLXZWCyrVGIAPiDehjnwWVDb95RhyaDcH15SseurrOmRIlrPYA4MuAhg5YwBYOPNHP3ZOPVDHXDCh852QYl00IdztD6IlqbScem8+r36Ik9XnWESdWIbEhVPg/53u7nKjH7ksRa+uX0VBaHqZ0h30l45vjA+mXE/rCnBh28kjJ88HEvXELQfkZf+KctoM8MiHUvP3jFRqICofaEXGK1LCw=="
        ];
      };
      infoscreen = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCjD7Vt+qzI3ubh0GBM32QeC8kpi8z9B4RhFH+o3RZvaGOZNU16tvrg/iIk8JtGl9eCOKlpksRgoTIloC83oJZAAcy9TdNMtzdC/VHP/BeCIX3c8a5Qg3WTDGlib2AWf9O61T2qX84dE60rWEqHhJ5LWws3tVG1Gd9j2Vz7uNExJnuWkn9mZ0l+VvLBhYnIp3Db4ZTSpKPFHWJr2tsDWVmYS/5loZBL+rqOuG7xa48Ltlfb8rHkrCkx3HcObHYjH7sMB0g2zKEidFvJL7FxkWP5XiK4XBk0UuhPzvmewNz6wBcJnEKmtBiYmMftmkZrgwwSDi2/VhDgeL8Ez9opwJn"
          "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA4FAeTJKuTHjKnr2ReiaJDbBxwdTYH6M7FWTzWv0MEXsfpny9Sf0HuDOYjVFxw0kLrdlGG+HwYT1j7ReZHhTYN0cRmYsyA12iVZl3nEvdZAB1b+O7KCnJ0dXnWGRJYJQ5GLXZWCyrVGIAPiDehjnwWVDb95RhyaDcH15SseurrOmRIlrPYA4MuAhg5YwBYOPNHP3ZOPVDHXDCh852QYl00IdztD6IlqbScem8+r36Ik9XnWESdWIbEhVPg/53u7nKjH7ksRa+uX0VBaHqZ0h30l45vjA+mXE/rCnBh28kjJ88HEvXELQfkZf+KctoM8MiHUvP3jFRqICofaEXGK1LCw=="
        ];
      };
      autossh.isNormalUser = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      neovim
      git
      htop
      (python3.withPackages (pypkgs: with pypkgs; [
        pyyaml
	pip
      ]))
      matchbox
      xdotool
      tmux
      toilet
      lxterminal
      surf
      feh
      youtube-dl
      termite.terminfo
      alacritty
      #qutebrowser
      cmatrix
      mosml
    ];

    shellAliases = { vim = "nvim"; };

    variables = {
      EDITOR = "nvim";
    };

    homeBinInPath = true;

    localBinInPath = true;
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" "brackets"];
      };
      ohMyZsh = {
        enable = true;
      };
    };
    ssh = {
      extraConfig = ''
        Host *
          TCPKeepAlive yes
          ExitOnForwardFailure yes
          ServerAliveCountMax 6
          ServerAliveInterval 20
          StreamLocalBindUnlink yes
      '';
    };
  };
  system.stateVersion = "24.05";
}
