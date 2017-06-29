{beforeEach, afterEach, describe, it} = global
{expect}      = require 'chai'
sinon         = require 'sinon'
shmock        = require '@octoblu/shmock'
request       = require 'request'
enableDestroy = require 'server-destroy'
Server        = require '../../src/server'

describe 'Connect to GMAIL', ->
  beforeEach (done) ->
    @logFn = sinon.spy()
    @fakeGmail =
      messages: sinon.stub()
    @fakeStream =
      on: sinon.stub()

    serverOptions =
      port: undefined,
      disableLogging: true
      logFn: @logFn
      fakeGmail: @fakeGmail

    @server = new Server serverOptions

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach ->
    @server.destroy()

  describe.only 'On GET /email', ->
    beforeEach (done) ->
      options =
        uri: '/email'
        baseUrl: "http://localhost:#{@serverPort}"
        json: true
        qs:
          apiKey: 'some-api-key'
          max:1

      @fakeGmail.messages.yields @fakeStream
      @fakeStream.on.yields null

      request.get options, (error, @response, @body) =>
        done error

    it 'should return a 200', ->
      expect(@response.statusCode).to.equal 200


  xdescribe 'when the service yields an error', ->
    beforeEach (done) ->
      userAuth = new Buffer('some-uuid:some-token').toString 'base64'

      @authDevice = @meshblu
        .post '/authenticate'
        .set 'Authorization', "Basic #{userAuth}"
        .reply 204

      options =
        uri: '/hello'
        baseUrl: "http://localhost:#{@serverPort}"
        auth:
          username: 'some-uuid'
          password: 'some-token'
        qs:
          hasError: true
        json: true

      request.get options, (error, @response, @body) =>
        done error

    it 'should log the error', ->
      expect(@logFn).to.have.been.called

    it 'should auth and response with 500', ->
      expect(@response.statusCode).to.equal 500
