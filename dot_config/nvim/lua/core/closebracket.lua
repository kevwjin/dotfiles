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

local function unclosed_context_suffix(line)
  local stack = {}
  local pairs = {
    ['('] = ')',
    ['['] = ']',
  }
  local matching_open = {
    [')'] = '(',
    [']'] = '[',
  }
  local in_string = false
  local escaped = false
  local i = 1

  while i <= #line do
    local char = line:sub(i, i)
    local next_char = line:sub(i + 1, i + 1)

    if in_string then
      if escaped then
        escaped = false
      elseif char == '\\' then
        escaped = true
      elseif char == '"' then
        in_string = false
      end
    elseif char == '"' then
      in_string = true
    elseif char == '/' and next_char == '/' then
      break
    elseif pairs[char] then
      table.insert(stack, char)
    elseif matching_open[char] then
      if stack[#stack] == matching_open[char] then
        table.remove(stack)
      end
    end

    i = i + 1
  end

  local suffix = ''
  for index = #stack, 1, -1 do
    suffix = suffix .. pairs[stack[index]]
  end

  return suffix
end

local function rust_needs_semicolon(line)
  if string.match(line, '^%s*let%s+.+%s+=%s*.+$') then
    return true
  end

  return string.match(line, '%.(modify|write|write_with_zero|update|replace)%s*%([^)]*$') ~= nil
end

local function rust_close_bracket()
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
  local line_to_cursor = line:sub(1, cursor_col)
  local suffix = unclosed_context_suffix(line_to_cursor)

  if suffix ~= '' then
    if rust_needs_semicolon(line_to_cursor) then
      suffix = suffix .. ';'
    end

    return '{<CR>}' .. suffix .. '<Esc>O'
  end

  if string.match(line, '^%s*let%s+.+%s+=%s+match%s+.+%s*$') then
    return '{<CR>};<Esc>O'
  end

  if string.match(line, '^%s*pub%s+use%s+.+::%s*$') or string.match(line, '^%s*use%s+.+::%s*$') then
    return '{<CR>};<Esc>O'
  end

  return '{<CR>}<Esc>O'
end

local function rust_close_paren()
  return '(<CR>)<Esc>O'
end

vim.keymap.set('i', '{<cr>', close_bracket, {
  expr = true,
  desc = 'Expand curly braces',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function(event)
    vim.keymap.set('i', '{<cr>', rust_close_bracket, {
      buffer = event.buf,
      expr = true,
      desc = 'Expand Rust curly braces',
    })
    vim.keymap.set('i', '(<cr>', rust_close_paren, {
      buffer = event.buf,
      expr = true,
      desc = 'Expand Rust parentheses',
    })
  end,
})
