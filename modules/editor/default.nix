{ pkgs, ... }: {

  # TODO VAMOS HELIX 
  programs.helix = { enable = true; };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;

    extraConfig = ''
      autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

      if has('nvim')
        let $GIT_EDITOR = 'nvr -cc split --remote-wait'
      endif

      function! RenameFile()
        let old_name = expand('%')
        let new_name = input('New file name: ', expand('%'), 'file')
        if new_name != '\' && new_name != old_name
          exec ':saveas ' . new_name
          exec ':silent !rm ' . old_name
          redraw!
        endif
      endfunction

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
        ${builtins.readFile ./nvim/neoai.lua}
        ${builtins.readFile ./nvim/cmp.lua}
      EOF
    '';

    plugins = with pkgs;
      with pkgs.vimPlugins;
      let
        virt-column = vimUtils.buildVimPlugin {
          name = "virt-column";
          src = fetchFromGitHub {
            owner = "lukas-reineke";
            repo = "virt-column.nvim";
            rev = "fe3cff94710d648c57ac826fb846014903c76b00";
            sha256 = "0m5b180ijk63ci4g1c8j1hi5ga4z6jcwfq8hv5kfmwjgiycf3wsc";
          };
        };
        co-pilot = vimUtils.buildVimPlugin {
          name = "copilot.vim";
          src = fetchFromGitHub {
            owner = "github";
            repo = "copilot.vim";
            rev = "69455be5d4a892206bc08365ba3648a597485943";
            sha256 = "0vcdfssw5nvdyxjq9d9vvdvvlwfr35cmrgrjc7ndbdxw778hsai0";
          };
        };

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

        # nix-prefetch-git https://github.com/Bryley/neoai.nvim --rev cdbc4c723577d642b5af796875dec660a4cb528b
        neoai = vimUtils.buildVimPlugin {
          name = "neoai";
          src = fetchFromGitHub {
            owner = "Bryley";
            repo = "neoai.nvim";
            rev = "14ffe5f1361bdfbd7667ca57cb07f52abcdcc00b";
            sha256 = "0mqrp9hpwrfdyjfpw85wmzd0qflx9pk4h50ax3r2snav61n9y6rg";
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
        co-pilot
        nui-nvim
        neoai
        # ChatGPT-vim
        # plenary-nvim

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
        virt-column
        # vim-markdown

        # Navigation
        nerdtree
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
        neoformat

        # Snippets
        vim-vsnip

        # Other
        vim-wakatime
      ];
  };
}
