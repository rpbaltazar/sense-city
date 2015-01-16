querystring = require("querystring")

root = (res, postData) ->
  console.log 'start method'
  body = '<html>'+
    '<head>'+
    '<meta http-equiv="Content-Type" content="text/html; '+
    'charset=UTF-8" />'+
    '</head>'+
    '<body>'+
    '<form action="/checkAwake" method="post">'+
    '<input type="text" name="uuid"></input>'+
    '<input type="submit" value="Submit" />'+
    '</form>'+
    '</body>'+
    '</html>'

  res.writeHead(200, {"Content-Type": "text/html"})
  res.write(body)
  res.end()

checkAwake = (res, postData) ->
  console.log postData
  uuid = querystring.parse(postData).uuid
  console.log "checking if your #{uuid} is awake"

  res.writeHead(200, {"Content-Type": "text/plain"})
  res.write("Yes! Your #{uuid} is awake")
  res.end()

exports.root = root
exports.checkAwake = checkAwake
