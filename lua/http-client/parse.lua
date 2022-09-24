local test = {
  'POST https://postman-echo.com/post',
  'content-type: application/json',
  '',
  '{',
  '"hello": "world"',
  '}',
  '',
  '###'
}

local function parseMethod(line)
  return line:sub(string.find(line, '^%u+'))
end

print(parseMethod(test[1]))

local function parseUrl(line)
  local _, finish = string.find(line, '%s+')
  return line:sub(finish + 1)
end

print(parseUrl(test[1]))
