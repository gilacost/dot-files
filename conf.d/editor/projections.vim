"""""""""""""""""""""" PROJECTIONS """"""""""""""""""""""""""""""""

  let g:projectionist_heuristics = {
      \  'rebar.config': {
      \     'src/*.erl': {
      \       'type': 'module',
      \       'alternate': 'test/{dirname}/{basename}_test.erl',
      \       'template': [
      \         '-module({basename|snakecase}).',
      \         '',
      \         '% Some func',
      \         '-spec some_func() -> ok.',
      \         'some_func() -> ok.',
      \       ]
      \     },
      \     '*_test.erl': {
      \       'type': 'test',
      \       'alternate': 'apps/{dirname}/src/{basename}.erl',
      \       'template': [
      \         '-module({basename|snakecase}).',
      \         '-include_lib("eunit/include/eunit.hrl").',
      \         '',
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
      \         '',
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
      \         '',
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
      \         '',
      \         '  alias {camelcase|capitalize|dot}',
      \         'end'
      \       ]
      \     }
      \   }
      \ }
