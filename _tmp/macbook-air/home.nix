{ config, pkgs, ... }: let
  link = config.lib.file.mkOutOfStoreSymlink;
  config-files = "${config.home.homeDirectory}/.config/nix-darwin/config";
in
{
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

  xdg.configFile."alacritty/alacritty.toml".source = link "${config-files}/alacritty/alacritty.toml";
  xdg.configFile."newsboat/config".source = link "${config-files}/newsboat/config";

  xdg.configFile."nvim" = {
    source = link "${config-files}/nvim";
    recursive = true;
  };

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
