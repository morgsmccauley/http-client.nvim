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
