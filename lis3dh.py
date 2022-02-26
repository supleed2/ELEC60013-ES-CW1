"""Library for interacting with LIS3DH triple-axis accelerometer."""

from importlib.resources import read_text
from tabnanny import check
import smbus2
from time import sleep

# Register addresses
_CTRL_REG1 = bytes([0x20])
_CTRL_REG2 = bytes([0x21])
_CTRL_REG3 = bytes([0x22])
_CTRL_REG4 = bytes([0x23])
_CTRL_REG5 = bytes([0x24])
_CTRL_REG6 = bytes([0x25])
_REF_REG = bytes([0x26])
_STATUS_REG = bytes([0x27])
_OUT_X_L = bytes([0x28])
_OUT_X_H = bytes([0x29])
_OUT_Y_L = bytes([0x2A])
_OUT_Y_H = bytes([0x2B])
_OUT_Z_L = bytes([0x2C])
_OUT_Z_H = bytes([0x2D])
_INT1_CFG = bytes([0x30])
_INT1_SRC = bytes([0x31])
_INT1_THS = bytes([0x32])
_INT1_DURATION = bytes([0x33])
_INT2_CFG = bytes([0x34])
_INT2_SRC = bytes([0x35])
_INT2_THS = bytes([0x36])
_INT2_DURATION = bytes([0x37])
_CLICK_CFG = bytes([0x38])
# Config flags
SAMPLERATE_1HZ  = bytes([0x17])
SAMPLERATE_10HZ = bytes([0x27])
SAMPLERATE_25HZ = bytes([0x37])
HP_DISABLE = bytes([0x00])
CTRL_REG3_V = bytes([0x40])
CTRL_REG4_V = bytes([0x00]) # sensitivity set to 2g
CTRL_REG5_V = bytes([0x08])
INT1_THS_V = bytes([0x16]) # free-fall threshold at 350 mg
INT1_DURATION_V = bytes([0x03])
INT1_CFG_V = bytes([0x95])
EMPTY = bytes([0x00])

class lis3dh:
    def __init__(self, i2cBus, i2cAddress=0x18, samplerate=SAMPLERATE_1HZ):
        sleep(0.005)
        self.i2c = i2cBus
        self.addr = i2cAddress
        self.samplerate = samplerate
        i2cBus.pec = True  # enable smbus2 Packet Error Checking

        #First try; configure beginning from 0x20 with MSB = 1 to increment
        config1 = smbus2.i2c_msg.write(self.addr, [0xC0,0x1F,0x00,0x00,0x00,0x00,0x00,0x00])
        config2 = smbus2.i2c_msg.write(self.addr, [0xB2,0x00,0x00]) #Configure 0x32 with MSB = 1 to increment
        config3 = smbus2.i2c_msg.write(self.addr, [0x30,0x00]) #Configure 0x30
        config4 = smbus2.i2c_msg.write(self.addr, [0x24,0x00]) #Configure 0x24 again
        self.i2c.i2c_rdwr(config1, config2, config3, config4)

    def readAll(self) -> list:
        check_status = smbus2.i2c_msg.write(self.addr, [0x27])
        x = smbus2.i2c_msg.read(self.addr, 1)
        y = smbus2.i2c_msg.read(self.addr, 1)
        z = smbus2.i2c_msg.read(self.addr, 1)
        prepare_x = smbus2.i2c_msg.write(self.addr, [0x28])
        prepare_y = smbus2.i2c_msg.write(self.addr, [0x2A])
        prepare_z = smbus2.i2c_msg.write(self.addr, [0x2C])
        status = smbus2.i2c_msg.read(self.addr, 1)
        self.i2c.i2c_rdwr(check_status, status)
        #while status.buf[0] != 0b1111:
        #    sleep(0.00001)
        self.i2c.i2c_rdwr(prepare_x, x, prepare_y, y, prepare_z, z)
        X = int.from_bytes(x.buf[0])
        Y = int.from_bytes(y.buf[0])
        Z = int.from_bytes(z.buf[0])
        return [X,Y,Z]