local test = {
  'POST https://postman-echo.com/post',
  'content-type: application/json',
  '',
  '{',
  '  "name": "morgan",',
  '  "age": 28',
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

local function parseHeader(line)
  local separatorStart, separatorFinish = string.find(line, ':%s+')
  return line:sub(0, separatorStart - 1), line:sub(separatorFinish + 1)
end

print(parseHeader(test[2]))
