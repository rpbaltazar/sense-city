server = require "./server"
router = require "./router"
requestHandler = require "./request-handler"

handle = {}
handle["/"] = requestHandler.root
handle["/checkAwake"] = requestHandler.checkAwake

server.start router.route, handle
