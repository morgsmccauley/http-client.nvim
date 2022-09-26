local M = {}

function M.method(line)
  return line:sub(string.find(line, '^%u+'))
end

function M.url(line)
  local _, finish = string.find(line, '%s+')
  return line:sub(finish + 1)
end

function M.header(line)
  local separatorStart, separatorFinish = string.find(line, ':%s+')
  return line:sub(0, separatorStart - 1), line:sub(separatorFinish + 1)
end

function M.body(lines)
  local body = ''
  for _, line in ipairs(lines) do
    body = body .. line
  end
  return vim.fn.json_decode(body)
end

function M.request(lines)
  local headers = {}
  local body = nil

  local requestLine = table.remove(lines, 1)
  local method = M.method(requestLine)
  local url = M.url(requestLine)

  repeat
    local line = table.remove(lines, 1)
    local header, value = M.header(line)
    headers[header] = value
  until lines[1] == '' or lines[1] == nil

  table.remove(lines, 1)

  if lines[1] == '{' then
    local jsonString = ''
    repeat
      local line = table.remove(lines, 1)
      jsonString = jsonString .. line
    until lines[1] == nil or lines[1] == ''
    body = vim.fn.json_decode(jsonString)
  end

  return method, url, headers, body
end

return M
