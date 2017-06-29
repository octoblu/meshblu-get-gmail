enableDestroy      = require 'server-destroy'
octobluExpress     = require 'express-octoblu'
MeshbluAuth        = require 'express-meshblu-auth'
Router             = require './router'
MeshbluGetGmailService = require './services/meshblu-get-gmail-service'

class Server
  constructor: (options) ->
    { @logFn, @disableLogging, @port, @fakeGmail } = options


  address: =>
    @server.address()

  run: (callback) =>
    app = octobluExpress({ @logFn, @disableLogging })

    meshbluGetGmailService = new MeshbluGetGmailService { @fakeGmail }
    router = new Router {@meshbluConfig, meshbluGetGmailService}

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

module.exports = Server
