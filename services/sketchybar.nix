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
}
