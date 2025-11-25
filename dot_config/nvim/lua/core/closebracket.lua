local function close_bracket()
  local line = vim.api.nvim_get_current_line()
  local filetype = vim.bo.filetype

  if string.match(line, '^%s*(struct|class|enum) ') then
    return '{<CR>}<Esc>O'
  elseif vim.fn.searchpair('(', '', ')', 'bmn', '', vim.fn.line('.')) ~= 0 then
    -- Probably inside a function call. Close it off.
    return '{<CR>})<Esc>O'
  else
    -- For Zig files, only add }; for everything else add };
    if filetype == 'zig' then
      return '{<CR>}<Esc>O'
    else
      return '{<CR>};<Esc>O'
    end
  end
end
vim.keymap.set('i', '{<cr>', close_bracket, {expr=true})
