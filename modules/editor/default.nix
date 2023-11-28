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

      let g:copilot_filetypes = {
        \ 'markdown': v:true
        \ }

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
      \     'lib/**/views/*_view.ex': {
      \       'type': 'view',
      \       'alternate': 'test/{dirname}/views/{basename}_view_test.exs',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View do',
      \         '  use {dirname|camelcase|capitalize}, :view',
      \         'end'
      \       ]
      \     },
      \     'test/**/views/*_view_test.exs': {
      \       'alternate': 'lib/{dirname}/views/{basename}_view.ex',
      \       'type': 'test',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ViewTest do',
      \         '  use ExUnit.Case, async: true',
      \         '\',
      \         '  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View',
      \         'end'
      \       ]
      \     },
      \     'lib/**/controllers/*_controller.ex': {
      \       'type': 'controller',
      \       'alternate': 'test/{dirname}/controllers/{basename}_controller_test.exs',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Controller do',
      \         '  use {dirname|camelcase|capitalize}, :controller',
      \         'end'
      \       ]
      \     },
      \     'test/**/controllers/*_controller_test.exs': {
      \       'alternate': 'lib/{dirname}/controllers/{basename}_controller.ex',
      \       'type': 'test',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ControllerTest do',
      \         '  use {dirname|camelcase|capitalize}.ConnCase, async: true',
      \         'end'
      \       ]
      \     },
      \     'lib/**/channels/*_channel.ex': {
      \       'type': 'channel',
      \       'alternate': 'test/{dirname}/channels/{basename}_channel_test.exs',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel do',
      \         '  use {dirname|camelcase|capitalize}, :channel',
      \         'end'
      \       ]
      \     },
      \     'test/**/channels/*_channel_test.exs': {
      \       'alternate': 'lib/{dirname}/channels/{basename}_channel.ex',
      \       'type': 'test',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ChannelTest do',
      \         '  use {dirname|camelcase|capitalize}.ChannelCase, async: true',
      \         '\',
      \         '  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel',
      \         'end'
      \       ]
      \     },
      \     'test/**/features/*_test.exs': {
      \       'type': 'feature',
      \       'template': [
      \         'defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Test do',
      \         '  use {dirname|camelcase|capitalize}.FeatureCase, async: true',
      \         'end'
      \       ]
      \     },
      \     'lib/*.ex': {
      \       'alternate': 'test/{}_test.exs',
      \       'type': 'source',
      \       'template': [
      \         'defmodule {camelcase|capitalize|dot} do',
      \         'end'
      \       ]
      \     },
      \     'test/*_test.exs': {
      \       'alternate': 'lib/{}.ex',
      \       'type': 'test',
      \       'template': [
      \         'defmodule {camelcase|capitalize|dot}Test do',
      \         '  use ExUnit.Case, async: true',
      \         '\',
      \         '  alias {camelcase|capitalize|dot}',
      \         'end'
      \       ]
      \     }
      \   }
      \ }

      let g:neoformat_prettier = {
        \ 'exe': '/etc/profiles/per-user/pepo/bin/prettier',
        \ 'args': ['--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ }

      let g:neoformat_hcl = {
       \ 'exe': '/etc/profiles/per-user/pepo/bin/packer',
       \ 'args': ['fmt', '-write', '-'],
       \ 'stdin': 1,
       \ }

      let g:neoformat_hcl_hclfmt = g:neoformat_hcl
      let g:neoformat_enabled_hcl = ['hclfmt']
      let g:neoformat_javascript_prettier = g:neoformat_prettier
      let g:neoformat_enabled_javascript = ['prettier']
      let g:neoformat_json_prettier = g:neoformat_prettier
      let g:neoformat_enabled_json = ['prettier']
      let g:neoformat_css_prettier = g:neoformat_prettier
      let g:neoformat_enabled_css = ['prettier']
      let g:neoformat_typescript_prettier = g:neoformat_prettier
      let g:neoformat_enabled_typescript = ['prettier']
      let g:neoformat_yaml_prettier = g:neoformat_prettier
      let g:neoformat_enabled_yaml = ['prettier']
         
      autocmd BufWritePre *.ex,*.exs,*.eex,*.leex,*.heex lua vim.lsp.buf.format()

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
            rev = "c7d166ebda265370f38cec374e33f02eeec2f857";
            sha256 = "1j2q62sac9gwcdzgc2cdxvvpxjgxi12sy33p49lk3gh5mlld53ij";
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

      in [
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
