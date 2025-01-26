local function close_bracket()
  local line = vim.api.nvim_get_current_line()

  if string.match(line, '^%s*(struct|class|enum) ') then
    return '{<CR>}<Esc>O'
  elseif vim.fn.searchpair('(', '', ')', 'bmn', '', vim.fn.line('.')) ~= 0 then
    -- Probably inside a function call. Close it off.
    return '{<CR>})<Esc>O'
  else
    return '{<CR>};<Esc>O'
  end
end
vim.keymap.set('i', '{<cr>', close_bracket, {expr=true})
