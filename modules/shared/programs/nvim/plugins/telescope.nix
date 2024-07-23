{
  plugins.telescope = {
    enable = true;

    settings = {
      pickers = {
        find_files = {
          hidden = true;
          file_ignore_patterns = ["^./.git/" "^node_modules/"];
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = ":Telescope find_files<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = ":Telescope live_grep<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = ":Telescope buffers<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = ":Telescope help_tags<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = ":Telescope current_buffer_fuzzy_find<CR>";
      options.silent = true;
    }
  ];
}
