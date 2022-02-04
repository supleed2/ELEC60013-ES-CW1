"""Library for interacting with TMP006 Thermopile (IR Temperature) Sensor."""

import smbus2
from time import sleep

# Pointer Register Locations
_REG_VOBJ = bytes([0x00])
_REG_TAMB = bytes([0x01])
_REG_CNFG = bytes([0x02])
_REG_M_ID = bytes([0xFE])
_REG_D_ID = bytes([0xFF])
# Configuration Flags
_MODE_ON = bytes([0x70])
SAMPLERATE_4HZ = bytes([0x00])
SAMPLERATE_2HZ = bytes([0x02])
SAMPLERATE_1HZ = bytes([0x04])
SAMPLERATE_0_5HZ = bytes([0x06])
SAMPLERATE_0_25HZ = bytes([0x08])
_DRDY_EN = bytes([0x01])


class TMP006:
    def __init__(self, i2cBus, i2cAddress=0x40, samplerate=SAMPLERATE_1HZ):
        self.i2c = i2cBus
        self.addr = i2cAddress
        self.samplerate = samplerate
        i2cBus.pec = True  # enable smbus2 Packet Error Checking
        self.config = bytes([0x00, 0x00])
        self.config = (
            self.config[0] | samplerate[0] | _MODE_ON[0] | _DRDY_EN[0] + self.config[1]
        )
        ptrConfig = smbus2.i2c_msg.write(self.addr, _REG_CNFG)
        writeConfig = smbus2.i2c_msg.write(self.addr, self.config)
        self.i2c.i2c_rdwr(ptrConfig, writeConfig)

    @property
    def temperature(self) -> float:
        Vobj = self.vObject()
        Tdie = self.tAmbient()
        # Values for Calculations
        S0 = 6.4e-14  # Calibration Factor TODO: Calibrate
        a1 = 1.75e-3
        a2 = -1.678e-5
        Tref = 298.15
        b0 = -2.94e-5
        b1 = -5.7e-7
        b2 = 4.63e-9
        c2 = 13.4
        # Calculate Sensitivity of Thermopile
        S = S0 * (1 + a1 * (Tdie - Tref) + a2 * ((Tdie - Tref) ** 2))
        # Calculate Coltage offset due to package thermal resistance
        Voffset = b0 + b1 * (Tdie - Tref) + b2 * ((Tdie - Tref) ** 2)
        # Calculate Seebeck coefficients
        fVobj = (Vobj - Voffset) + c2 * ((Vobj - Voffset) ** 2)
        # Calculate object temperature in Kelvin
        Tobj = (Tdie**4 + (fVobj / S)) ** 0.25
        # Convert from Kelvin to Celsius
        return Tobj - 273.15

    @property
    def active(self) -> bool:
        """Check if Sensor is powered on."""
        ptrPower = smbus2.i2c_msg.write(self.addr, _REG_CNFG)
        power = smbus2.i2c_msg.read(self.addr, 2)
        self.i2c.i2c_rdwr(ptrPower, power)
        return power.buf[0] & _MODE_ON[0] != 0

    @active.setter
    def active(self, value: bool):
        """Set the sensor to active or inactive."""
        if value:
            ptrPower = smbus2.i2c_msg.write(self.addr, _REG_CNFG)
            power = smbus2.i2c_msg.read(self.addr, 2)
            self.i2c.i2c_rdwr(ptrPower, power)
            newPower = power.buf[0] | _MODE_ON[0] + power.buf[1]
            updatePower = smbus2.i2c_msg.write(self.addr, newPower)
            self.i2c.i2c_rdwr(ptrPower, updatePower)
        else:
            ptrPower = smbus2.i2c_msg.write(self.addr, _REG_CNFG)
            power = smbus2.i2c_msg.read(self.addr, 2)
            self.i2c.i2c_rdwr(ptrPower, power)
            newPower = power.buf[0] & ~_MODE_ON[0] + power.buf[1]
            updatePower = smbus2.i2c_msg.write(self.addr, newPower)
            self.i2c.i2c_rdwr(ptrPower, updatePower)

    def vObject(self) -> float:
        """Reading from Sensor Voltage Register in Volts"""
        ptrVobject = smbus2.i2c_msg.write(self.addr, _REG_VOBJ)
        readVobject = smbus2.i2c_msg.read(self.addr, 2)
        self.i2c.i2c_rdwr(ptrVobject, readVobject)
        scaledVoltage = int.from_bytes(
            readVobject.buf[0] + readVobject.buf[1], byteorder="big", signed=True
        )
        return round(scaledVoltage * 156.25e-9, 1)
        # convert to Volts (156.25nV per LSB * 1e-9 for scaling from nV to Volts)

    def tAmbient(self) -> float:
        """Reading from Ambient Temperature Register in Degrees Celsius"""
        ptrTambient = smbus2.i2c_msg.write(self.addr, _REG_TAMB)
        readTambient = smbus2.i2c_msg.read(self.addr, 2)
        self.i2c.i2c_rdwr(ptrTambient, readTambient)
        scaledTemp = int.from_bytes(
            readTambient.buf[0] + readTambient.buf[1], byteorder="big", signed=True
        )
        return round(scaledTemp * 0.0078125, 1)
        # convert to degrees Celsius (1/32 for scaling * 1/4 for 2 bit shift)

    @property
    def manID(self) -> bytes:
        """Sensor manufacturer ID"""
        ptrManID = smbus2.i2c_msg.write(self.addr, _REG_M_ID)
        readManID = smbus2.i2c_msg.read(self.addr, 2)
        self.i2c.i2c_rdwr(ptrManID, readManID)
        return readManID.buf[0] + readManID.buf[1]

    @property
    def devID(self) -> bytes:
        """Sensor device ID"""
        ptrDevID = smbus2.i2c_msg.write(self.addr, _REG_D_ID)
        readDevID = smbus2.i2c_msg.read(self.addr, 2)
        self.i2c.i2c_rdwr(ptrDevID, readDevID)
        return readDevID.buf[0] + readDevID.buf[1]
