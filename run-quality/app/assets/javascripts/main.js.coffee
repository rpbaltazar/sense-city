window.RunQuality = {}

_.extend RunQuality,
  initMap: (mapReady) ->
    callback = mapReady || defaultMapReady
    @mapManager = new RunQuality.MapManager('Google', 'map', callback)
    @apiManager = new RunQuality.ApiManager('http://localhost:3000')

  defaultMapReady: ->
    console.log 'map ready'
