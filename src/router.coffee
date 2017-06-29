MeshbluGetGmailController = require './controllers/meshblu-get-gmail-controller'

class Router
  constructor: ({ @meshbluGetGmailService }) ->
    throw new Error 'Missing meshbluGetGmailService' unless @meshbluGetGmailService?

  route: (app) =>
    meshbluGetGmailController = new MeshbluGetGmailController { @meshbluGetGmailService }

    app.get '/email', meshbluGetGmailController.getEmail
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
