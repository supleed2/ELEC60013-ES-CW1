# ELEC60013 Embedded Systems: Coursework 1

## Project name: Barkr

- A pet-tracking IoT device without the need for embedded GPS - location is tracked using AirTag-style broadcasts and the FindMy network, significantly improving battery life. 
- Various sensors (accelerometer, temperature, humidity) are connected to a Raspberry Pi Zero W, allowing real-time monitoring of pet's health and environment metrics. 
- Data is processed and stored using a backend written in Python Flask and Firebase.
- User app, written in Flutter, allowing the user to see the current location of their pet, alongside air and skin temperature, humidity, and step count.

## Repository Sections

- [App](./App/): The user app, written in Flutter
- [DataPuller](./DataPuller/): Data fetching script to pull data from cloud sources and forward to our backend, eg. AirTags DB or an MQTT broker
- [RPi](./RPi/): Program to run on the IOT device itself, collecting pet information for the app and acts as a bluetooth beacon
- [Server](./Server/): Backend for interacting with the Firebase Database and providing user registration abilities
- [Website](./Website/): Static marketting website built using Hugo, live at <https://barkr.8bitsqu.id/>

## Contributors

- [Aadi](https://github.com/supleed2/)
- [Benjamin](https://github.com/bo3z/)
- [Kacper](https://github.com/kmn219/)
