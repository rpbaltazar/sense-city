# Sense-city

## Sensors used

The sensor box is composed by 6 sensors, a wifi module and a seeeduino.
The available sensors and it's units (according to the code notes):

| Sensor      | Units                   |
-----------------------------------------
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
