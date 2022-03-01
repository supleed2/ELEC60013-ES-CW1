"""Library for interacting with LIS3DH triple-axis accelerometer."""

from importlib.resources import read_text
from re import S
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
    def __init__(self, i2cBus, samplerate=10, i2cAddress=0x18):
        sleep(0.005)
        self.i2c = i2cBus
        self.addr = i2cAddress
        self.samplerate = samplerate
        i2cBus.pec = True  # enable smbus2 Packet Error Checking
        sample_modes = {
            0:0x0, 1:0x1, 10:0x2, 25:0x3, 50:0x4,
            100:0x5, 200:0x6, 400:0x7
        }

        # Check if user-entered values are correct
        if samplerate in sample_modes:
            self.samplerate = sample_modes[samplerate]
        else:
            raise Exception("Invalid sample rate.")

        # Configure all registers in +-2g mode
        c0 = smbus2.i2c_msg.write(self.addr, [0x20,(sample_modes[samplerate]<<4)|0xF]) # Initialise in low power mode
        c1 = smbus2.i2c_msg.write(self.addr, [0x21,0x0A])
        c2 = smbus2.i2c_msg.write(self.addr, [0x22,0x40])
        c3 = smbus2.i2c_msg.write(self.addr, [0x23,0x00])
        c4 = smbus2.i2c_msg.write(self.addr, [0x24,0x0A])
        c5 = smbus2.i2c_msg.write(self.addr, [0x25,0x20])
        c6 = smbus2.i2c_msg.write(self.addr, [0x2E,0x00])
        c7 = smbus2.i2c_msg.write(self.addr, [0x30,0x95])
        c8 = smbus2.i2c_msg.write(self.addr, [0x32,0x16])
        c9 = smbus2.i2c_msg.write(self.addr, [0x33,0x03])
        c10 = smbus2.i2c_msg.write(self.addr, [0x34,0x3F])
        c11 = smbus2.i2c_msg.write(self.addr, [0x36,0x4A])
        c12 = smbus2.i2c_msg.write(self.addr, [0x24,0x0A]) # Configure 0x24 again
        self.i2c.i2c_rdwr(c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12)

    def resetint1(self) -> bool:
        '''Read INT1_SRC to reset it after an interrupt event.'''
        int1_src_loc = smbus2.i2c_msg.write(self.addr, [0x31])
        read_int1_src = smbus2.i2c_msg.read(self.addr, 1)
        self.i2c.i2c_rdwr(int1_src_loc,read_int1_src)
        if read_int1_src.bug[0] != None:
            return True
        else:
            return False
        
    def resetint2(self) -> bool:
        '''Read INT2_SRC to reset it after an interrupt event.'''
        int2_src_loc = smbus2.i2c_msg.write(self.addr, [0x35])
        read_int2_src = smbus2.i2c_msg.read(self.addr, 1)
        self.i2c.i2c_rdwr(int2_src_loc,read_int2_src)
        if read_int2_src.bug[0] != None:
            return True
        else:
            return False

    def readAll(self) -> list:
        '''Read acceleration data from all axes. Returns values as a list [X,Y,Z].'''
        check_status = smbus2.i2c_msg.write(self.addr, [0x27])
        x = smbus2.i2c_msg.read(self.addr, 1)
        y = smbus2.i2c_msg.read(self.addr, 1)
        z = smbus2.i2c_msg.read(self.addr, 1)
        prepare_x = smbus2.i2c_msg.write(self.addr, [0x29])
        prepare_y = smbus2.i2c_msg.write(self.addr, [0x2B])
        prepare_z = smbus2.i2c_msg.write(self.addr, [0x2D])
        status = smbus2.i2c_msg.read(self.addr, 1)
        self.i2c.i2c_rdwr(check_status, status)

        while status.buf[0][0] & 0b1111 != 0b1111: # Wait for data to be available
            sleep(0.001)
            self.i2c.i2c_rdwr(check_status, status)

        if status.buf[0][0] & 0b1111 == 0b1111: # If data is available, read
            self.i2c.i2c_rdwr(prepare_x, x)
            self.i2c.i2c_rdwr(prepare_y, y)
            self.i2c.i2c_rdwr(prepare_z, z)
            X = int.from_bytes(x.buf[0],"big")
            Y = int.from_bytes(y.buf[0],"big")
            Z = int.from_bytes(z.buf[0],"big")

            # Convert from binary 2s complement to useful data
            new_values = []
            for D in [X,Y,Z]:
                MSB = D >> 7
                if MSB == 1:
                    res = (-128 + (D - 128))*self.resolution/128
                else:
                    res = (D*self.resolution)/128
                new_values.append(res)

            return new_values
        else:
            return None # Should never get here lol