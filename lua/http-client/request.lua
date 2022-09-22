local curl = require('plenary.curl')

local res = curl.get('https://postman-echo.com/get', {
  query = {
    hello = 'world'
  }
})

print(vim.inspect(res))
