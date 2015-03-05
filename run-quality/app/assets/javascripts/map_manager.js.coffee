class RunQuality.MapManager
  constructor: (mapProvider, cssId, callback) ->
    @handler = Gmaps.build('Google')
    @cssId = cssId
    @defaultCenterCoordinates = {latitude: 1.3000, longitude: 103.8000}
    @markersSet = {}

    @handler.buildMap {
      provider: {}
      internal: id: @cssId
    }, =>
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition(@_displayOnMap)
      else
        @_displayOnMap()
      callback()

  addMarkers: (markers, setId) ->
    if @markersSet[setId]?
      @_removeMarkers(@markersSet[setId])

    addedMarkers = @handler.addMarkers markers
    @markersSet[setId] = addedMarkers

  removeMarkers: (setId) ->
    if @markersSet[setId]?
      @_removeMarkers(@markersSet[setId])

  _removeMarkers: (markers) ->
    console.log 'removeMarkers', markers
    @handler.removeMarkers(markers)

  _displayOnMap: (position) =>
    if position?
      center = new google.maps.LatLng position.coords.latitude, position.coords.longitude
    else
      center =  new google.maps.LatLng @defaultCenterCoordinates.latitude, @defaultCenterCoordinates.longitude

    @handler.map.centerOn(center)
