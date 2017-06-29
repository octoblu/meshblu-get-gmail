class MeshbluGetGmailController
  constructor: ({@meshbluGetGmailService}) ->
    throw new Error 'Missing meshbluGetGmailService' unless @meshbluGetGmailService?

  getEmail: (request, response) =>
    { hasError, apiKey, max=10 } = request.query
    return response.sendError(new Error "Missing in querystring: apiKey") unless apiKey?
    @meshbluGetGmailService.getEmail { hasError, apiKey, max }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(200)

module.exports = MeshbluGetGmailController
