# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class RunQuality.HomePage
  constructor: ->
    RunQuality.initMap(@_mapLoadedCallback) if _.isUndefined RunQuality.mapManager
    @currentFilterDistance = 5

  updateMaxDistance: (evt) ->
    newDistance = evt.value
    if @currentFilterDistance != newDistance
      #updateUIValue
      @currentFilterDistance = newDistance

  filterRoutes: (evt) =>
    RunQuality.apiManager.fetchRoutes({maxDistance: @currentFilterDistance}, @_routesSuccess)

  _mapLoadedCallback: =>
    RunQuality.apiManager.fetchSensors(null, @_sensorsSuccess)
    @_setupListeners()

  _sensorsSuccess: (sensorMarkers) =>
    RunQuality.mapManager.addMarkers sensorMarkers, "sensors"

  _routesSuccess: (routesMarkers) =>
    RunQuality.mapManager.addMarkers routesMarkers, "routeCentroids"

  _setupListeners: =>
    google.maps.event.addListener(RunQuality.mapManager.handler.getMap(), 'zoom_changed', @_zoomChanged)

  _zoomChanged: =>
    zoomLevel = RunQuality.mapManager.handler.getMap().getZoom()
    console.log zoomLevel

    if zoomLevel >= 12
      #fetch near routes
      center = RunQuality.mapManager.handler.getMap().getCenter()
      RunQuality.apiManager.fetchRoutes(@_routesSuccess)
    else
      RunQuality.mapManager.removeMarkers("routeCentroids")

ready = ->
  homePage = new RunQuality.HomePage()

  $("#distance-filter").slider(
    id: "distance-filter"
    min: 5
    max: 20
    step: 1
    orientation: 'horizontal'
    value: 5
    tooltip: 'Max distance of route centroid to sensor in kms'
    handle: 'round'
  ).on('slide', homePage.updateMaxDistance)
    .on('slideStop', homePage.filterRoutes)



$(document).ready(ready)
$(document).on('page:load', ready)
