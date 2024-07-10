{ pkgs, lib, config, ... }:

{
  options.hesoyam.enable = {
    type = lib.types.bool;
    default = false;
    description = "hesoyam";
  };

  config = lib.mkIf config.hesoyam.enable {
    programs.kdeconnect.enable = true;
  };
}
