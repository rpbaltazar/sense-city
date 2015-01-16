http = require 'http'
url = require 'url'

start = (route, handle) ->
  onRequest = (req, res) ->
    postData = ""
    pathname = url.parse(req.url).pathname
    req.setEncoding 'utf8'

    req.addListener "data", (chunck) ->
      postData += chunck

    req.addListener "end", () ->
      console.log "Request for #{pathname} received"
      route(pathname, handle, res, postData)

  http.createServer(onRequest).listen(8888)
  console.log 'Server is on!'

exports.start = start
