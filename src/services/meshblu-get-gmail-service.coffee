Gmail = require 'node-gmail-api'

class MeshbluGetGmailService
  constructor: ({@fakeGmail }) ->

  getEmail: ({ hasError, apiKey, max }, callback) =>
    console.log 'getEmail->'
    console.log 'API KEY: ', apiKey
    return callback @_createError('Error!') if hasError?
    gmail = @fakeGmail || new Gmail apiKey
    s = gmail.messages('label:inbox', {max})
    s.on 'data', (result) =>
      console.log result
      callback()

  _createError: (message='Internal Service Error', code=500) =>
    error = new Error message
    error.code = code
    return error

module.exports = MeshbluGetGmailService
