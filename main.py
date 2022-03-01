from lis3dh import *
from datetime import datetime
import signal
import sys
import RPi.GPIO as GPIO

print("Raspberry Pi Zero W, up and running!")
bus = smbus2.SMBus(1)
accel = lis3dh(bus,2,1)

print("LIS3DH initiated successfully!")

INT1 = 18
INT2 = 17

def signal_handler(sig,frame):
    GPIO.cleanup()
    sys.exit(0)

def int1_callback(channel):
    # do something here

GPIO.setmode(GPIO.BCM)

# # Data logging
# now = datetime.now()
# date_time = now.strftime("%d_%m_%Y_%H_%M_%S")
# name = "output_"+date_time+".txt"
# f = open(name,"x")
# print("X","Y","Z", file=f)
# f.close()

while True:
    [X,Y,Z] = accel.readAll()
    print("X: ",X,"\tY: ",Y,"\t Z: ",Z,"\n")
    # with open(name,"a") as f:
    #     print(X,Y,Z, file=f)