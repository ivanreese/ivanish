Hapi = require('hapi')
Path = require('path')

logErr = (err)-> console.log(err) if err

server = new Hapi.Server
  connections: routes: files: relativeTo: Path.join __dirname, 'public'
server.connection(port: process.env.PORT or 3000)
server.register require('inert'), logErr
server.register require('vision'), logErr

server.route
  method: 'GET'
  path: '/{param*}'
  handler:
    directory:
      path: '.'
      index: true

server.start (err)->
  if err? then throw err
  console.log 'Server running at:', server.info.uri
