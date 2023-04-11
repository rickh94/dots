{ ... }:
{
  xdg.configFile."sketchybar/sketchybarrc" = {
    executable = true;
    source = ./sketchybar/sketchybarrc;
  };

  xdg.configFile."sketchybar/colors.sh" = {
    executable = true;
    source = ./sketchybar/colors.sh;
  };

  xdg.configFile."sketchybar/icons.sh" = {
    executable = true;
    source = ./sketchybar/icons.sh;
  };

  xdg.configFile."sketchybar/items" = {
    executable = true;
    source = ./sketchybar/items;
  };

  xdg.configFile."sketchybar/plugins" = {
    executable = true;
    source = ./sketchybar/plugins;
  };
  # xdg.configFile."sketchybar/items/spaces.sh" = {
  #   executable = true;
  #   source = ./sketchybar/items/spaces.sh;
  # };
  #
  # xdg.configFile."sketchybar/plugins/space.sh" = {
  #   executable = true;
  #   source = ./sketchybar/plugins/space.sh;
  # };
  #
  # xdg.configFile."sketchybar/items/front_app.sh" = {
  #   executable = true;
  #   source = ./sketchybar/items/front_app.sh;
  # };
  #
  # xdg.configFile."sketchybar/plugins/yabai.sh" = {
  #   executable = true;
  #   source = ./sketchybar/plugins/yabai.sh;
  # };
  #
  # xdg.configFile."sketchybar/items/spotify.sh" = {
  #   executable = true;
  #   source = ./sketchybar/items/spotify.sh;
  # };
  #
  # xdg.configFile."sketchybar/plugins/spotify.sh" = {
  #   executable = true;
  #   source = ./sketchybar/plugins/spotify.sh;
  # };
  #
  # xdg.configFile."sketchybar/items/battery.sh" = {
  #   executable = true;
  #   source = ./sketchybar/items/battery.sh;
  # };
  #
  # xdg.configFile."sketchybar/plugins/battery.sh" = {
  #   executable = true;
  #   source = ./sketchybar/plugins/battery.sh;
  # };
  #
  # xdg.configFile."sketchybar/items/volume.sh" = {
  #   executable = true;
  #   source = ./sketchybar/items/volume.sh;
  # };
  #
  # xdg.configFile."sketchybar/plugins/volume.sh" = {
  #   executable = true;
  #   source = ./sketchybar/plugins/volume.sh;
  # };
  #
  # xdg.configFile."sketchybar/plugins/volume_click.sh" = {
  #   executable = true;
  #   source = ./sketchybar/plugins/volume_click.sh;
  # };
}
