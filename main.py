import os, sys
from time import sleep
from strictyaml import load, Map, Str, YAMLError
import paho.mqtt.client as mqtt
import json, smbus2, si7201, tmp006, hci, gpiozero

# Global Sensor Data Variables
dailysteps = 0
fallen = False

def incrementStepCount() -> None:
    global dailysteps
    dailysteps += 1

def setFallen() -> None:
    global fallen
    fallen = True

# Setup
bus = smbus2.SMBus(1)  # set up I2C bus 1

temphum = si7201.Si7201(bus, 0x40)  # set up Si7201 sensor
temphum.reset()  # reset Si7201

irtemp = tmp006.TMP006(bus, 0x41, tmp006.SAMPLERATE_4HZ)  # set up TMP006 sensor
irtemp.active = 1  # turn on TMP006

# accel = lis3dh.LIS3DH(bus, 0x18, otherconfigflags) # set up LIS3DH sensor
# TODO: other LIS3DH Setup
step = gpiozero.Button(18, pull_up = False)  # GPIO18: Step Counter Interrupt (INT1)
step.when_activated = incrementStepCount  # increment step count when Step Counter Interrupt (INT1) is triggered
fall = gpiozero.Button(17, pull_up = False)  # GPIO17: Freefall Interrupt (INT2)
fall.when_activated = setFallen  # set fallen to True when Freefall Interrupt (INT2) is triggered

with open(".secrets.yml", "r") as secrets:
    try:
        secrets = load(secrets, schema = Map({"key": Str()}))
        key = secrets["key"]  # Get Base64 encoded device public key from secrets file
    except YAMLError as exc:
        print(exc)
        sleep(60) # 60s delay before restarting
        os.execl(sys.executable, os.path.abspath(__file__), *sys.argv) # Restart propgram
btcast = hci.HCIBroadcaster(key)  # set up HCI Broadcaster

client = mqtt.Client("RaspberryPi")  # set up MQTT client
client.connect("add8.duckdns.org", 8883, 60)  # connect to MQTT broker
client.loop_start() # Start a new thread to handle sending MQTT messages

# Main Loop
while True:
    data = {
        "devID": "testdoggo",
        "air_temp": temphum.temperature,
        "day_steps": dailysteps,
        "hum_perc": temphum.humidity,
        "pet_temp": irtemp.temperature
    }
    mqtt_data = json.dumps(data)
    client.publish("/data", mqtt_data)
    btcast.start_advertising()  # Send out BT advertisement
    sleep(5)  # Sleep for 5 seconds to lower power consumption
