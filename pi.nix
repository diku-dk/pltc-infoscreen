{ config, pkgs, lib, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
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
    };
  };

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    allowedUsers = [ "@wheel" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  security = {
    sudo.execWheelOnly = true;
    sudo.wheelNeedsPassword = false;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    kernelParams = [
        "8250.nr_uarts=1"
        "console=ttyAMA0,115200"
        "console=tty1"
        "cma=128M"
    ];

    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
      };
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "pltc-pi";
    extraHosts = "45.76.37.241 abc\n107.189.30.63 nixvps\n";
  };

  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    xserver = {
      enable = true;
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
	#setupCommands = ''
	#  xset -dpms; xset s off; xset s noblank
	#'';
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

  environment = {
    systemPackages = with pkgs; [
      neovim
      git
      python3
      matchbox
      xdotool
      tmux
      toilet
      lxterminal
      surf
      feh
      youtube-dl
      python3Packages.pip
      python3Packages.pyyaml
      termite.terminfo
    ];

    shellAliases = { vim = "nvim"; };

    variables = {
      EDITOR = "nvim";
    };
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
        plugins = [ "git" ];
        theme = "fishy";
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

  system.stateVersion = "21.05";
}
