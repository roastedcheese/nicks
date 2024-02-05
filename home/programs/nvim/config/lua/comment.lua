return {
  'numToStr/Comment.nvim',
  config = function()
    require("Comment").setup({
      toggler = {
          ---Line-comment toggle keymap
          line = '<leader>//',
          ---Block-comment toggle keymap
          block = '<leader>b/',
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
          ---Line-comment keymap
          line = '<leader>/',
          ---Block-comment keymap
          block = '<leader>b',
      },
      ---LHS of extra mappings
      extra = {
          ---Add comment on the line above
          above = '<leader>/O',
          ---Add comment on the line below
          below = '<leader>/o',
          ---Add comment at the end of line
          eol = '<leader>/A',
      },
    })
  end,

  opts = {
  }
}
