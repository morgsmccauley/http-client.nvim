local mock = require('luassert.mock')
local stub = require('luassert.stub')

local parse = require('lua.http-client.parse')

describe('parse', function()
  describe('method', function()
    it('parses leading uppercase word', function()
      assert.same(parse.method('GET https://postman-echo.com/get'), 'GET')
    end)

    it('handles multiple spaces', function()
      assert.same(parse.method('POST   https://postman-echo.com/post'), 'POST')
    end)
  end)

  describe('url', function()
    it('parses the url', function()
      assert.same(parse.url('DELETE https://postman-echo/delete'), 'https://postman-echo/delete')
    end)

    it('handles multiple spaces', function()
      assert.same(parse.url('DELETE  https://postman-echo/delete'), 'https://postman-echo/delete')
    end)
  end)

  describe('header', function()
    it('parses header to tuple', function()
      local header, value = parse.header('content-type: application/json')
      assert.same(header, 'content-type')
      assert.same(value, 'application/json')
    end)
  end)

  describe('body', function()
    it('parses body to table', function()
      local decodedJson = {
        name = 'morgan'
      }

      _G.vim = {
        fn = {
          json_decode = function()
            return decodedJson
          end
        }
      }

      assert.same(
        parse.body({
          '{',
          '  "name": "morgan",',
          '}',
        }),
        decodedJson
      )
    end)
  end)
end)
