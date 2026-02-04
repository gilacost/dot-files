{ pkgs, ... }:
{

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;

    extraConfig = ''
      function! s:list_buffers()
          redir => list
          silent ls
          redir END
          return split(list, "\n")
      endfunction

      set noswapfile

      command! BD call fzf#run(fzf#wrap({
        \ 'source': s:list_buffers(),
        \ 'sink*': { lines -> s:delete_buffers(lines) },
        \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
        \ }))

      function! s:delete_buffers(lines)
        execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[0]}))
      endfunction

      let g:projectionist_heuristics = {
      \  'rebar.config': {
      \     'apps/**/src/*.erl': {
      \       'type': 'module',
      \       'alternate': 'test/{dirname}/{basename}_test.erl',
      \       'template': [
      \         '-module({basename|snakecase}).',
      \         '\',
      \         '% Some func',
      \         '-spec some_func() -> ok.',
      \         'some_func() -> ok.',
      \       ]
      \     },
      \     'test/**/*_test.erl': {
      \       'type': 'test',
      \       'alternate': 'apps/{dirname}/src/{basename}.erl',
      \       'template': [
      \         '-module({basename|snakecase}).',
      \         '-include_lib("eunit/include/eunit.hrl").',
      \         '\',
      \         '% This should fail',
      \         'basic_test_() ->',
      \         '   ?assert(1 =:= 2).',
      \       ]
      \     }
      \  },
      \  'mix.exs': {
      \     'lib/*.ex': {
      \       'type': 'lib',
      \       'alternate': 'test/{}_test.exs',
      \     },
      \     'test/*_test.exs': {
      \       'alternate': 'lib/{}.ex',
      \       'type': 'test',
      \     }
      \   }
      \ }

      lua << EOF
        -- Primary stable LSP (lexical)
        vim.g.lsp_elixir_bin = "/Users/pepo/.elixir-lsp/lexical-wrapper.sh"
        -- Experimental LSP (expert) - available at /Users/pepo/.elixir-lsp/expert-wrapper.sh
        ${builtins.readFile ./nvim/base.lua}
        ${builtins.readFile ./nvim/lsp.lua}
        ${builtins.readFile ./nvim/sets.lua}
        ${builtins.readFile ./nvim/terminal.lua}
        ${builtins.readFile ./nvim/treesitter.lua}
        ${builtins.readFile ./nvim/theme.lua}
        ${builtins.readFile ./nvim/telescope.lua}
        ${builtins.readFile ./nvim/lspkind.lua}
        ${builtins.readFile ./nvim/cmp.lua}
        ${builtins.readFile ./nvim/nvim-tree.lua}
        ${builtins.readFile ./nvim/git.lua}
        ${builtins.readFile ./nvim/harpoon.lua}
        ${builtins.readFile ./nvim/which-key.lua}
        ${builtins.readFile ./nvim/flash.lua}
        ${builtins.readFile ./nvim/oil.lua}
      EOF
    '';
    # ${builtins.readFile ./nvim/mcphub.lua}
    # ${builtins.readFile ./nvim/avante.lua}
    # ${builtins.readFile ./nvim/neoai.lua}
    # vim.g.lsp_elixir_bin = "${pkgs.lexical}/bin/lexical"
    plugins =
      with pkgs;
      with pkgs.vimPlugins;
      let
        # nix-prefetch-git https://github.com/gilacost/vim-wakatime --rev cad0dabbad61f0116fcdc2142b98a5bc63b00d0d
        vim-wakatime = vimUtils.buildVimPlugin {
          name = "vim-wakatime";
          src = fetchFromGitHub {
            owner = "gilacost";
            repo = "vim-wakatime";
            rev = "cad0dabbad61f0116fcdc2142b98a5bc63b00d0d";
            sha256 = "0yj7j6saismvk4753lb86w2b3z4npbd9l8lfv5vzcargc1drx5qh";
          };
        };

        # avante-nvim = pkgs.vimUtils.buildVimPlugin {
        #   name = "avante-nvim";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "yetone";
        #     repo = "avante.nvim";
        #     rev = "v0.0.22";
        #     sha256 = "sha256-m33yNoGnSYKfjTuabxx/QsMptiUxAcP8NVe/su+JfkE=";
        #   };
        #   dontBuild = true;
        #   doCheck = false;
        # };

        nvim-tree-lua = vimUtils.buildVimPlugin {
          name = "nvim-tree-lua";
          src = fetchFromGitHub {
            owner = "nvim-tree";
            repo = "nvim-tree.lua";
            rev = "c7639482a1598f4756798df1b2d72f79fe5bb34f";
            sha256 = "1wxlb9z3kv0h88lsx18qsiwvaw6bc9gxr9byx5qlzmibfd1kipff";
          };
        };

        # nix-prefetch-git https://github.com/jackMort/ChatGPT.nvim  --rev af509fceb70cab1867a611f3d8fad6d3e7760fb0
        # ChatGPT-vim = vimUtils.buildVimPlugin {
        #   name = "ChatGPT.nvim";
        #   src = fetchFromGitHub {
        #     owner = "jackMort";
        #     repo = "vim-wakatime";
        #     rev = "af509fceb70cab1867a611f3d8fad6d3e7760fb0";
        #     sha256 = "0h34m91fm1bpy7zi643y6i0l0zlkbq6r1w6b3xqvnbjjny2zh6md";
        #   };
        # };

      in
      [
        # mcphub-nvim
        plenary-nvim
        dressing-nvim
        nui-nvim
        # avante-nvim
        img-clip-nvim

        # Enhanced navigation
        harpoon
        which-key-nvim
        flash-nvim
        oil-nvim

        vim-test
        virt-column-nvim
        tokyonight-nvim
        nui-nvim
        # neoai
        # ChatGPT-vim
        # plenary-nvim
        # copilot-vim

        ###REVIEW###
        # indentLine
        ##REVIEW###

        # Git
        vim-fugitive
        vim-gitgutter
        vim-rhubarb # review

        # Programming
        emmet-vim
        (nvim-treesitter.withAllGrammars)
        # nvim-treesitter-refactor
        # nvim-treesitter-textobjects
        vim-vsnip
        vim-vsnip-integ
        vim-jsonnet

        # Appearance
        barbar-nvim
        catppuccin-nvim
        lspkind-nvim
        lualine-nvim
        nvim-web-devicons
        # vim-markdown

        # Navigation
        nvim-tree-lua
        # nerdtree
        vim-easymotion
        vim-startify
        telescope-nvim
        telescope-symbols-nvim
        trouble-nvim
        vim-cool
        vim-rooter

        # Pope
        vim-surround
        vim-commentary
        vim-unimpaired
        vim-projectionist
        vim-speeddating # review this
        vim-vinegar
        vim-abolish

        # Linting / Fixing / Lsp
        # lspsaga-nvim
        cmp-nvim-lsp
        cmp-buffer
        nvim-cmp
        nvim-lspconfig
        # neoformat

        # Snippets
        vim-vsnip

        # Other
        vim-wakatime
      ];
  };
}
