# Sense-city

## Sensors used

The sensor box is composed by 6 sensors, a wifi module and a seeeduino.
The available sensors and it's units (according to the code notes):

| Sensor      | Units                   |
|-------------|-------------------------|
| Air quality |                         |
| Humidity    | %                       |
| Dust        | pcs/0.01cf or pcs/283ml |
| Light       | lux                     |
| UV          | mv                      |
| Sound       | mv                      |
| Temperature | C                       |

```
The code notes say that the temperature is collected in F, but looking at the values returned by my sensor, it is registering in C.
```

## File structure

### endomondo

Contains some files of a short experiment with endomondo data. It turned out not to be so easy to grab the data from there, so I've postponed the work with that data

### is-my-sensor-up

Draft of a rails application that intended to check if a specific sensor was up. Datacanvas released a website that already gives that information, so it is frozen for now

### map-my-fitness

#### mapmyfitness.py

Using the API available under [Under Armour](https://developer.underarmour.com) I've written a script that grabs the existing routes around a location (for now is using statically singapore coordinates) and saves the route to a csv file.

This script requires that you configure and load the environment variables ```MMF_CLIENT_ID``` and ```MMF_CLIENT_SECRET``` with the values you can get after registering your app on the underarmour website.
It also expects that you can set the ```MMF_CLIENT_TOKEN``` to avoid making the request for the authtoken everytime you want to start making requests.

#### geographic-midpoint-calculator.rb

Ruby script that parses a csv file and calculates the geographical midpoint following the center of gravity algorithm explained [here](http://www.geomidpoint.com/example.html)
