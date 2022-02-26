from . import lis3dh.py

print("Raspberry Pi Zero W, up and running!")

accel = lis3dh()

print("LIS3DH initiated successfully!")

while True:
    [X,Y,Z] = accel.readAll()
    print("X: ",X,"\tY: ",Y,"\t Z: ",Z,"\n")