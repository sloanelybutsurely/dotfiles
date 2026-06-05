{ config, pkgs, ... }: {
  home.username = "sloane";
  home.homeDirectory = "/Users/sloane";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    fd
    jujutsu
    neovim
    difftastic
    htop
    wget
    zellij
    aerc
    newsboat
  ];

  programs.fish = {
    enable = true;
    shellAbbrs = {
      j = "jj";
    };
    functions = {
      rebuild-system = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin#(hostname)";
    };
  };
  programs.zoxide.enable = true;
}
