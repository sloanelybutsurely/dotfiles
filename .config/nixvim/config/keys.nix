{
  plugins.which-key = {
    enable = true;
    keyLabels = {
      "<space>" = "SPC";
      "<cr>" = "RET";
      "<tab>" = "TAB";
    };
    registrations = {
      "<leader>g" = "Git";
    };
  };

  globals.mapleader = " ";

  keymaps = [
    { key = ";"; action = ":"; }
    { key = "q;"; action = "q:"; }

    { key = "<leader>y"; action = "\"+y"; }
    { key = "<leader>Y"; action = "\"+Y"; }
    { key = "<leader>p"; action = "\"+p"; }
    { key = "<leader>P"; action = "\"+P"; }

    { key = "<leader>w"; action = "<cmd>w<cr>"; }
    { key = "<leader>q"; action = "<cmd>q<cr>"; }
    { key = "<esc>"; action = "<cmd>nohlsearch<cr>"; mode = "n"; }

    # root level leader commands
    {
      key = "<leader><space>";
      action = "<cmd>Telescope find_files<cr>"; 
      options = { desc = "Find files in project"; };
    }
    {
      key = "<leader>/";
      action = "<cmd>Telescope live_grep<cr>"; 
      options = { desc = "Search project"; };
    }
    {
      key = "<leader><tab>";
      action = "<cmd>NERDTreeToggle<cr>"; 
      options = { desc = "Toggle NERDTree"; };
    }

    # git
    {
      key = "<leader>gs";
      action = "<cmd>Git<cr>"; 
      options = { desc = "Status"; };
    }
    {
      key = "<leader>gp";
      action = "<cmd>Git push<cr>"; 
      options = { desc = "Push"; };
    }
    {
      key = "<leader>gP";
      action = "<cmd>Git push --force-with-lease<cr>"; 
      options = { desc = "Push (force with lease)"; };
    }
    {
      key = "<leader>gf";
      action = "<cmd>Git fetch<cr>"; 
      options = { desc = "Fetch"; };
    }
    # git rebase
    {
      key = "<leader>gro";
      action = "<cmd>Git rebase origin/main<cr>"; 
      options = { desc = "origin/main"; };
    }
    {
      
      key = "<leader>grO";
      action = "<cmd>Git rebase --interactive origin/main<cr>"; 
      options = { desc = "-i origin/main"; };
    }
    {
      
      key = "<leader>grm";
      action = "<cmd>Git rebase origin/master<cr>"; 
      options = { desc = "origin/master"; };
    }
    {
      key = "<leader>grM";
      action = "<cmd>Git rebase --interactive origin/master<cr>"; 
      options = { desc = "-i origin/master"; };
    }
  ];
}
