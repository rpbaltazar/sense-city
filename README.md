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

```
Copied from datacanvas website:

The pollution indicator measures when harmful target gases (such as secondhand smoke, carbon monoxide, alcohol, etc.) are triggered and expresses their combined concentration in raw voltage. The output is raw voltage and the unit is mV. Higher mV is associated with increased pollutant gases. Peaks may happen around rush hour, when a bus or truck drives by, or during construction. You can access the data sheet for the air quality sensor here.
The dust sensor measures the concentration of particulate matters (PM) above 1 micrometer in diameter. This sensor has a detection range of of [0-28’000 pcs/liter]. This sensor tells us the concentration of particulate matter per liter of air and the unit is pcs/Liter. pcs stands for pieces, or simply particles. You can access the data sheet for the dust sensor here (PDF).
The humidity sensor measures relative humidity (RH), which is expressed as percentage and calculates the absolute humidity relative to the maximum for that temperature. This sensor can detect RH from 5 to 99% and operates within temperatures from minus 40 to 80 degree celsius. You can access the data sheet for the humidity sensor here (PDF).
The light sensor measures digital light, or illuminance, measured in lux. Illuminance is a measure of how much luminous flux is spread over a given area, while luminous flux is a measure of the total “amount” of visible light present. See details about comparative lux values on Wikipedia. You can access the data sheet for the light sensor here (PDF).
The noise sensor measures the raw output voltage of the sensor based on noise in the nearby environment in mV. To roughly convert these measurements to decibel (dB), use the formula dB = 0.0158x + 49.184, where x is the value output by the sensor. You can access the data sheet for the sound sensor here.
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
