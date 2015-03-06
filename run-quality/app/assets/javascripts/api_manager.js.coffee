class RunQuality.ApiManager
  constructor: (baseUrl) ->
    @baseUrl = baseUrl || "http://localhost:3000/"

  fetchSensors: (data, successCallback, errorCallback) ->
    url = "/sensors"
    success = successCallback || @genericErrorHandler
    error = errorCallback || @genericErrorHandler
    @getRequest(url, data, success, error)

  fetchRoutes: (data, successCallback, errorCallback) ->
    url = "/routes"
    success = successCallback || -> console.log('success callback not implemented')
    error = errorCallback || -> console.log('error callback not implemented')
    @getRequest(url, data, success, error)

  fetchRoute: (id, successCallback, errorCallback) ->
    url = "/routes/#{id}"
    success = successCallback || -> console.log('success callback not implemented')
    error = errorCallback || -> console.log('error callback not implemented')
    @getRequest(url, null, success, error)


  getRequest: (urlAppend, data, successCallback, errorCallback) ->
    url = @baseUrl+urlAppend
    $.get(url, data).done(successCallback).fail(errorCallback)


  genericErrorHandler: ->
    console.log "Error fetching: ", arguments
