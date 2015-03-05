class RunQuality.ApiManager
  constructor: (baseUrl) ->
    @baseUrl = baseUrl || "http://localhost:3000/"

  fetchSensors: (data, successCalback, errorCallback) ->
    url = "/sensors"
    success = successCalback || @genericErrorHandler
    error = errorCallback || @genericErrorHandler
    @getRequest(url, data, success, error)

  fetchRoutes: (data, successCalback, errorCallback) ->
    url = "/routes"
    success = successCalback || -> console.log('success callback not implemented')
    error = errorCallback || -> console.log('error callback not implemented')
    @getRequest(url, data, success, error)

  getRequest: (urlAppend, data, successCallback, errorCallback) ->
    url = @baseUrl+urlAppend
    $.get(url, data).done(successCallback).fail(errorCallback)


  genericErrorHandler: ->
    console.log "Error fetching: ", arguments
