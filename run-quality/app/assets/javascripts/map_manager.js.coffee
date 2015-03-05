class RunQuality.MapManager
  constructor: (mapProvider, cssId) ->
    @handler = Gmaps.build('Google')
    @cssId = cssId

    @handler.buildMap {
      provider: {}
      internal: id: @cssId
    }, ->
      console.log 'callback of map done'

  addMarkers: (markers) ->
