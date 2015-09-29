Hapi = require('hapi')
Path = require('path')

logErr = (err)-> console.log(err) if err

server = new Hapi.Server()
server.connection(port: 3000)
server.register require('inert'), logErr
server.register require('vision'), logErr

server.route
  method: 'GET'
  path: '/{param*}'
  handler:
    directory:
      path: 'public'
      index: true

server.route
  method: 'GET'
  path: '/items'
  handler: (req, rep)-> rep("Sup?")

server.start (err)->
  if err? then throw err
  console.log 'Server running at:', server.info.uri
