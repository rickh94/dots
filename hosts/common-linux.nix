{ config, lib, pkgs, ...}:
{
  home.packages = with pkgs; [
    tigervnc
  ];
}
