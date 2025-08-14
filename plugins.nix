{
  vimPlugins,
  blink-cmp ? vimPlugins.blink-cmp,
}:
with vimPlugins;
[
  nvim-treesitter.withAllGrammars
  mini-nvim
  blink-cmp
]
