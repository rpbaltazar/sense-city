window.RunQuality = {}

_.extend RunQuality,
  initMap: ->
    @mapManager = new RunQuality.MapManager('Google', 'map')
    @apiManager = new RunQuality.ApiManager('http://localhost:3000')
