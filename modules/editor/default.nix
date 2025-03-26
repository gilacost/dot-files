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
        vim.g.lsp_elixir_bin = "${pkgs.elixir_ls}/bin/elixir-ls"
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
      EOF
    '';
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

        # # nix-prefetch-git https://github.com/Bryley/neoai.nvim --rev cdbc4c723577d642b5af796875dec660a4cb528b
        # neoai = vimUtils.buildVimPlugin {
        #   name = "neoai";
        #   src = fetchFromGitHub {
        #     owner = "Bryley";
        #     repo = "neoai.nvim";
        #     rev = "14ffe5f1361bdfbd7667ca57cb07f52abcdcc00b";
        #     sha256 = "0mqrp9hpwrfdyjfpw85wmzd0qflx9pk4h50ax3r2snav61n9y6rg";
        #   };
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
        vim-test
        virt-column-nvim
        tokyonight-nvim
        nui-nvim
        # neoai
        # ChatGPT-vim
        # plenary-nvim
        copilot-vim

        ###REVIEW###
        # indentLine
        ##REVIEW###

        # Git
        vim-fugitive
        vim-gitgutter
        vim-rhubarb # review

        # Programming
        emmet-vim
        nvim-treesitter
        nvim-treesitter-refactor
        nvim-treesitter-textobjects
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
