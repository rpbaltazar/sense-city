class RunQuality.ApiManager
  constructor: (baseUrl) ->
    @baseUrl = baseUrl || "http://localhost:3000/"

  fetchSensors: (successCalback, errorCallback) ->
    url = "/sensors"
    success = successCalback || -> console.log('success callback not implemented')
    error = errorCallback || -> console.log('error callback not implemented')
    @getRequest(url, success, error)

  getRequest: (urlAppend, successCallback, errorCallback) ->
    url = @baseUrl+urlAppend
    $.get(url).done(successCallback).fail(errorCallback)
