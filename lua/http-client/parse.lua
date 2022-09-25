local function parseMethod(line)
  return line:sub(string.find(line, '^%u+'))
end

print(parseMethod('POST https://postman-echo.com/post'))

local function parseUrl(line)
  local _, finish = string.find(line, '%s+')
  return line:sub(finish + 1)
end

print(parseUrl('POST https://postman-echo.com/post'))

local function parseHeader(line)
  local separatorStart, separatorFinish = string.find(line, ':%s+')
  return line:sub(0, separatorStart - 1), line:sub(separatorFinish + 1)
end

print(parseHeader('content-type: application/json'))

local function parseBody(lines)
  local body = ''
  for _, line in ipairs(lines) do
    body = body .. line
  end
  return vim.fn.json_decode(body)
end

vim.pretty_print(parseBody({
  '{',
  '  "name": "morgan",',
  '  "age": 28,',
  '  "address": {',
  '    "number": 123,',
  '    "street": "fake st",',
  '    "city": "california"',
  '  }',
  '}',
}))

local function parseRequest(lines)
  local headers = {}
  local body = nil

  local requestLine = table.remove(lines, 1)
  local method = parseMethod(requestLine)
  local url = parseUrl(requestLine)

  repeat
    local line = table.remove(lines, 1)
    local header, value = parseHeader(line)
    headers[header] = value
  until lines[1] == '' or lines[1] == nil

  local line = table.remove(lines, 1)

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

vim.pretty_print(parseRequest({
  'POST https://postman-echo.com/post',
  'content-type: application/json',
  'origin: neovim',
  '',
  '{',
  '  "name": "morgan",',
  '  "age": 28,',
  '  "address": {',
  '    "number": 123,',
  '    "street": "fake st",',
  '    "city": "california"',
  '  }',
  '}',
}))
