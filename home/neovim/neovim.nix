{
  pkgs,
  lib,
  cyberdream,
  local,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme.enable = lib.mkForce false;

      globals = {
        user42 = local.gitName;
        mail42 = local.mail42;
        mapleader = " ";
      };

      options = {
        number = true;
        relativenumber = true;
        tabstop = 4;
        shiftwidth = 4;
        expandtab = false;
        scrolloff = 8;
      };

      treesitter = {
        enable = true;
        addDefaultGrammars = true;
      };

      autopairs.nvim-autopairs.enable = true;

      binds.whichKey.enable = true;

      languages = {
        tex = {
          enable = true;
          treesitter.enable = true;
          format.enable = true;
        };
        clang = {
          enable = true;
          treesitter.enable = true;
        };
        nix = {
          enable = true;
          treesitter.enable = true;
        };
        bash = {
          enable = true;
          treesitter.enable = true;
        };
      };

      git = {
        enable = true;
        gitsigns = {
          enable = true;
          codeActions.enable = true;
        };
      };

      telescope = {
        enable = true;
        mappings = {
          findFiles = "<leader>ff";
          liveGrep = "<leader>fg";
          buffers = "<leader>fb";
          helpTags = "<leader>fh";
        };
      };

      statusline.lualine.enable = true;

      filetree.nvimTree = {
        enable = true;
        mappings.toggle = "<leader>e";
        setupOpts = lib.mkForce {};
      };

      extraPlugins = {
        ccc-nvim = {
          package = pkgs.vimPlugins.ccc-nvim;
        };
        vim-42header = {
          package = pkgs.vimUtils.buildVimPlugin {
            name = "vim-42header";
            src = pkgs.fetchFromGitHub {
              owner = "42Paris";
              repo = "42header";
              rev = "0b5698ad1c7cc6d43783419d97c8e6cf97088e64";
              hash = "sha256-xdH/SeGv1bfKMmJ9cHYd5V+ynFohzprnUC8eVer1VcI=";
            };
          };
        };
        cyberdream-nvim = {
          package = pkgs.vimUtils.buildVimPlugin {
            name = "cyberdream.nvim";
            src = cyberdream.outPath;
          };
        };
        markview-nvim = {
          package = pkgs.vimPlugins.markview-nvim;
        };
      };

      luaConfigPost = ''
        vim.opt.termguicolors = true

        local raw_hex_ns = vim.api.nvim_create_namespace("raw_hex_colors")
        local function raw_hex_fg(hex)
          local r = tonumber(hex:sub(1, 2), 16)
          local g = tonumber(hex:sub(3, 4), 16)
          local b = tonumber(hex:sub(5, 6), 16)
          if (0.299 * r + 0.587 * g + 0.114 * b) > 128 then
            return "#000000"
          end
          return "#ffffff"
        end
        local function update_raw_hex_highlights(bufnr)
          bufnr = bufnr or vim.api.nvim_get_current_buf()
          if not vim.api.nvim_buf_is_valid(bufnr) then return end
          vim.api.nvim_buf_clear_namespace(bufnr, raw_hex_ns, 0, -1)
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          for i, line in ipairs(lines) do
            local init = 1
            while true do
              local s, e, hex = line:find([=[["'](%x%x%x%x%x%x)["']]=], init)
              if not s then break end
              local hl = "RawHex" .. hex:upper()
              vim.api.nvim_set_hl(0, hl, { bg = "#" .. hex, fg = raw_hex_fg(hex) })
              vim.api.nvim_buf_set_extmark(bufnr, raw_hex_ns, i - 1, s, {
                end_col = e - 1,
                hl_group = hl,
              })
              init = e + 1
            end
          end
        end
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
          pattern = { "*.yaml", "*.yml" },
          callback = function(ev) update_raw_hex_highlights(ev.buf) end,
        })

        require("ccc").setup({ highlighter = { auto_enable = true } })
        require("cyberdream").setup({
          italic_comments = true,
          colors = {
            bg            = "#000000",
            bg_alt        = "#1a0c14",
            bg_highlight  = "#36192a",
            fg            = "#edbac3",
            grey          = "#a85e74",
            blue          = "#a060d8",
            green         = "#b05c82",
            cyan          = "#f49ab0",
            red           = "#e82050",
            yellow        = "#f0d090",
            magenta       = "#e070c0",
            pink          = "#f49ab0",
            orange        = "#f08a5c",
            purple        = "#e070c0",
          },
        })
        vim.cmd("colorscheme cyberdream")
        require("markview").setup({
          preview = {
            filetypes = { "markdown", "tex", "typst" },
          },
        })
        require("lualine").setup({ options = { theme = "cyberdream" } })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "nix",
          callback = function()
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.expandtab = true
          end,
        })
      '';

      keymaps = [
        {
          key = "<leader>cp";
          mode = ["n"];
          action = ":CccPick<CR>";
          desc = "Open Color Picker";
        }
        {
          key = "<F1>";
          mode = ["n"];
          action = ":Stdheader<CR>";
          desc = "Insert 42 header";
        }
        {
          key = "<C-BS>";
          mode = ["i"];
          action = "<C-w>";
          desc = "delete previous word";
        }
        {
          key = "<leader>n";
          mode = ["n"];
          action = ":!norminette %<CR>";
          desc = "Run norminette on current file";
        }
        {
          key = "<leader>m";
          mode = ["n"];
          action = ":Markview toggle<CR>";
          desc = "markdown viewer toggle";
        }
      ];
    };
  };
}
