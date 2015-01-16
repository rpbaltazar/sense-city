route = (pathname, handle, res, postData) ->
  console.log "routing #{pathname} || #{postData}"
  if typeof handle[pathname] is 'function'
    handle[pathname](res, postData)
  else
    console.log "No request handle found for #{pathname}"
    res.writeHead 404,
      {"Content-type": "text/plain"}
    res.write "404 Not Found"
    res.end()

exports.route = route
