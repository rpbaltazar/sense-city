# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class RunQuality.HomePage
  constructor: ->
    RunQuality.initMap(@_mapLoadedCallback) if _.isUndefined RunQuality.mapManager
    @currentFilterDistance = 20

  updateMaxDistance: (evt) =>
    newDistance = evt.value
    if @currentFilterDistance != newDistance
      $("#distance-value").text(newDistance)
      @currentFilterDistance = newDistance

  filterRoutes: (evt) =>
    RunQuality.apiManager.fetchRoutes({max_distance: @currentFilterDistance}, @_routesSuccess)

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
      RunQuality.apiManager.fetchRoutes({max_distance: @currentFilterDistance}, @_routesSuccess)
      @_toggleRouteFiltering('enable')
    else
      @_toggleRouteFiltering('disable')
      RunQuality.mapManager.removeMarkers("routeCentroids")

  _toggleRouteFiltering: (value) ->
    $("#distance-filter").slider(value)

ready = ->
  homePage = new RunQuality.HomePage()

  $("#distance-filter").slider(
    id: "distance-filter-slider"
    min: 1
    max: 20
    step: 1
    orientation: 'horizontal'
    value: 20
    tooltip: 'show'
    handle: 'round'
    enabled: false
  ).on('slide', homePage.updateMaxDistance)
    .on('slideStop', homePage.filterRoutes)


$(document).ready(ready)
$(document).on('page:load', ready)
