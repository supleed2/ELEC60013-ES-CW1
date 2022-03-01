from lis3dh import *
from datetime import datetime

print("Raspberry Pi Zero W, up and running!")
bus = smbus2.SMBus(1)
accel = lis3dh(bus,2,10)

print("LIS3DH initiated successfully!")

name = "output_"+datetime.now()+".txt"
f = open(name,"x")
print("X","Y","Z", file=f)
f.close()

while True:
    [X,Y,Z] = accel.readAll()
    with open("output.txt","a") as f:
        print("X: ",X,"\tY: ",Y,"\t Z: ",Z,"\n")
        print(X,Y,Z, file=f)