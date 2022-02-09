from time import sleep
import smbus2
import si7201
import tmp006

bus = smbus2.SMBus(1)  # set up I2C bus 1

print("========== Testing Si7201 ==========")
temphumsensor = si7201.Si7201(bus)  # set up Si7201 sensor
temphumsensor.reset()  # reset the sensor
sleep(1)  # wait for sensor to reset
print(temphumsensor.temperature)  # read the temperature and print
print(temphumsensor.humidity)  # read the humidity and print

print("========== Testing TMP006 ==========")
irtempsensor = tmp006.TMP006(bus, 0x41, tmp006.SAMPLERATE_4HZ)  # set up TMP006 sensor
irtempsensor.active(1)  # turn on the sensor
sleep(1)  # wait for sensor to turn on
print(irtempsensor.manID)  # read the manufacturer ID and print
print(irtempsensor.devID)  # read the device ID and print
print(irtempsensor.temperature)  # read the temperature and print

print("========= TMP006 Test Loop =========")
while True:
    print(irtempsensor.temperature)  # read the temperature and print
    sleep(1)  # wait for 1 second
