"""Library for interacting with Si7201 Temperature & Humidity Sensor."""

import smbus2
from time import sleep


class Si7201:
    def __init__(self, i2cBus, i2cAddress=0x40):
        self.i2c = i2cBus
        self.addr = i2cAddress
        i2cBus.pec = True  # enable smbus2 Packet Error Checking

    @property
    def temperature(self, decimals=1):
        """Measured temperature in degrees Celsius, with configurable decimal places, default 1."""
        measure_temp = smbus2.i2c_msg.write(self.addr, [0xF3])
        read_temp = smbus2.i2c_msg.read(self.addr, 2)
        self.i2c.i2c_rdwr(measure_temp)
        sleep(0.1)
        self.i2c.i2c_rdwr(read_temp)
        temp_code = int.from_bytes(read_temp.buf[0] + read_temp.buf[1], "big")
        temp = round(((175.72 * temp_code) / 65536 - 46.85), decimals)
        return temp

    @property
    def humidity(self, decimals=1):
        """Measured relative humidity in percent, with configurable decimal places, default 1."""
        measure_hum = smbus2.i2c_msg.write(self.addr, [0xF5])
        read_rh = smbus2.i2c_msg.read(self.addr, 2)
        self.i2c.i2c_rdwr(measure_hum)
        sleep(0.1)
        self.i2c.i2c_rdwr(read_rh)
        rh_code = int.from_bytes(read_rh.buf[0] + read_rh.buf[1], "big")
        hum = round((125 * rh_code) / 65536 - 6.0, decimals)
        return hum

    def reset(self):
        """Reset the sensor."""
        resetcmd = smbus2.i2c_msg.write(self.addr, [0xFE])
        self.i2c.i2c_rdwr(resetcmd)
