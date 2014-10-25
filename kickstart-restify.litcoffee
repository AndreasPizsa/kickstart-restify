## Setup our Server

    _ = require 'lodash'

    module.exports = (options)->
      {log,nconf,pkginfo,_} = options

      restify = require 'restify'
      server  = restify.createServer
        name: "#{pkginfo.name} #{pkginfo.version}"
        log : log

      server.pre restify.pre.sanitizePath()

      server.use restify.requestLogger()
      server.use restify.authorizationParser()
      server.use restify.queryParser()
      server.use restify.jsonp()
      server.use restify.bodyParser()

      server.on 'uncaughtException', (request, response, route, error)->
        server.log {req:request,res:response,route:route, error:error}, 'Uncaught Exception'

      server.listen nconf.get('PORT'), ()->
        log.info
          name: server.name
          url : server.url
        , 'Server Listening'

      return _.extend options, {
        restify :restify
        server  :server
      }
