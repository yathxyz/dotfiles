{ pkgs, config, lib, ... }:

{
  options.yathshell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Collection of options regarding my shell setup";
    };

    config = lib.mkIf yathshell.enable { home.programs.fzf.enable = true; };
  };
}
