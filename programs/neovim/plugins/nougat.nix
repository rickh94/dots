{ unstablePkgs, ... }:
let
  nougat = unstablePkgs.vimUtils.buildVimPlugin {
    pname = "nougat-nvim";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/MunifTanjim/nougat.nvim";
      ref = "HEAD";
    };
  };
in
{
  /*
    rosewater = "#f5e0dc",
    flamingo = "#f2cdcd",
    pink = "#f5c2e7",
    mauve = "#cba6f7",
    red = "#f38ba8",
    maroon = "#eba0ac",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = "#89b4fa",
    lavender = "#b4befe",
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface2 = "#585b70",
    surface1 = "#45475a",
    surface0 = "#313244",
    base = "#1e1e2e",
    mantle = "#181825",
    crust = "#11111b",
  */
  programs.neovim = {
    plugins = [
      nougat
    ];
    extraPackages = [
    ];
    extraLuaConfig =
      /*
      lua
      */
      ''
        local core = require("nougat.core")
        local Bar = require("nougat.bar")
        local bar_util = require("nougat.bar.util")
        local Item = require("nougat.item")
        local sep = require("nougat.separator")

        local nut = {
          buf = {
            diagnostic_count = require("nougat.nut.buf.diagnostic_count").create,
            filename = require("nougat.nut.buf.filename").create,
            filestatus = require("nougat.nut.buf.filestatus").create,
            filetype = require("nougat.nut.buf.filetype").create,
          },
          git = {
            branch = require("nougat.nut.git.branch").create,
            status = require("nougat.nut.git.status"),
          },
          tab = {
            tablist = {
              tabs = require("nougat.nut.tab.tablist").create,
              close = require("nougat.nut.tab.tablist.close").create,
              icon = require("nougat.nut.tab.tablist.icon").create,
              label = require("nougat.nut.tab.tablist.label").create,
              modified = require("nougat.nut.tab.tablist.modified").create,
            },
          },
          mode = require("nougat.nut.mode").create,
          spacer = require("nougat.nut.spacer").create,
          truncation_point = require("nougat.nut.truncation_point").create,
        }

        local color = {
          bg = "#1d2021",
          bg0_h = "#1d2021",
          bg0 = "#282828",
          bg0_s = "#32302f",
          bg1 = "#3c3836",
          bg2 = "#504945",
          bg3 = "#665c54",
          bg4 = "#7c6f64",

          gray = "#928374",

          fg = "#ebdbb2",
          fg0 = "#fbf1c7",
          fg1 = "#ebdbb2",
          fg2 = "#d5c4a1",
          fg3 = "#bdae93",
          fg4 = "#a89984",

          lightgray = "#a89984",

          red = "#f38ba8",
          green = "#a6e3a1",
          yellow = "#f9e2af",
          blue = "#89b4fa",
          purple = "#b4befe",
          aqua = "#89dceb",
          orange = "#fab387",

          accent = {
            red = "#f5e0dc",
            green = "#94e2d5",
            yellow = "#cba6f7",
            blue = "#74c7ec",
            purple = "#f5c2e7",
            aqua = "#b3ebf5",
            orange = "#cba6f7",
          },
        }

        local mode = nut.mode({
          prefix = " ",
          suffix = " ",
          sep_right = sep.right_lower_triangle_solid(true),
          config = {
            highlight = {
              normal = {
                bg = "fg",
                fg = color.bg,
              },
              visual = {
                bg = color.orange,
                fg = color.bg,
              },
              insert = {
                bg = color.blue,
                fg = color.bg,
              },
              replace = {
                bg = color.purple,
                fg = color.bg,
              },
              commandline = {
                bg = color.green,
                fg = color.bg,
              },
              terminal = {
                bg = color.accent.green,
                fg = color.bg,
              },
              inactive = {},
            },
          },
        })

        local stl = Bar("statusline")
        stl:add_item(mode)
        stl:add_item(nut.git.branch({
          hl = { bg = color.purple, fg = color.bg },
          prefix = "  ",
          suffix = " ",
          sep_right = sep.right_upper_triangle_solid(true),
        }))
        stl:add_item(nut.git.status.create({
          hl = { fg = color.bg },
          content = {
            nut.git.status.count("added", {
              hl = { bg = color.green },
              prefix = "+",
              sep_right = sep.right_upper_triangle_solid(true),
            }),
            nut.git.status.count("changed", {
              hl = { bg = color.blue },
              prefix = "~",
              sep_right = sep.right_upper_triangle_solid(true),
            }),
            nut.git.status.count("removed", {
              hl = { bg = color.red },
              prefix = "-",
              sep_right = sep.right_upper_triangle_solid(true),
            }),
          },
        }))
        local filename = stl:add_item(nut.buf.filename({
          hl = { bg = color.bg3 },
          prefix = " ",
          suffix = " ",
        }))
        local filestatus = stl:add_item(nut.buf.filestatus({
          hl = { bg = color.bg3 },
          suffix = " ",
          sep_right = sep.right_lower_triangle_solid(true),
          config = {
            modified = "",
            nomodifiable = "",
            readonly = "",
            sep = " ",
          },
        }))
        stl:add_item(nut.spacer())
        stl:add_item(nut.truncation_point())
        stl:add_item(nut.buf.diagnostic_count({
          sep_left = sep.left_lower_triangle_solid(true),
          prefix = " ",
          suffix = " ",
          config = {
            error = { prefix = " ", fg = color.red },
            warn = { prefix = " ", fg = color.yellow },
            info = { prefix = " ", fg = color.blue },
            hint = { prefix = " ", fg = color.green },
          },
        }))
        stl:add_item(nut.buf.filetype({
          hl = { bg = color.bg1 },
          sep_left = sep.left_lower_triangle_solid(true),
          prefix = " ",
          suffix = " ",
        }))
        stl:add_item(Item({
          hl = { bg = color.bg2, fg = color.blue },
          sep_left = sep.left_lower_triangle_solid(true),
          prefix = "  ",
          content = core.group({
            core.code("l"),
            ":",
            core.code("c"),
          }),
          suffix = " ",
        }))
        stl:add_item(Item({
          hl = { bg = color.blue, fg = color.bg },
          sep_left = sep.left_lower_triangle_solid(true),
          prefix = " ",
          content = core.code("P"),
          suffix = " ",
        }))

        local stl_inactive = Bar("statusline")
        stl_inactive:add_item(mode)
        stl_inactive:add_item(filename)
        stl_inactive:add_item(filestatus)
        stl_inactive:add_item(nut.spacer())

        bar_util.set_statusline(function(ctx)
          return ctx.is_focused and stl or stl_inactive
        end)

        local tal = Bar("tabline")

        tal:add_item(nut.tab.tablist.tabs({
          active_tab = {
            hl = { bg = color.bg0_h, fg = color.blue },
            prefix = " ",
            suffix = " ",
            content = {
              nut.tab.tablist.icon({ suffix = " " }),
              nut.tab.tablist.label({}),
              nut.tab.tablist.modified({ prefix = " ", config = { text = "●" } }),
              nut.tab.tablist.close({ prefix = " ", config = { text = "󰅖" } }),
            },
            sep_right = sep.right_lower_triangle_solid(true),
          },
          inactive_tab = {
            hl = { bg = color.bg2, fg = color.fg2 },
            prefix = " ",
            suffix = " ",
            content = {
              nut.tab.tablist.icon({ suffix = " " }),
              nut.tab.tablist.label({}),
              nut.tab.tablist.modified({ prefix = " ", config = { text = "●" } }),
              nut.tab.tablist.close({ prefix = " ", config = { text = "󰅖" } }),
            },
            sep_right = sep.right_lower_triangle_solid(true),
          },
        }))

        bar_util.set_tabline(tal)
      '';
  };
}
