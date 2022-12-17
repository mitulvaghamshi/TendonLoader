"""
This is an extracted part (method) from the API
provided by the Tindeq team to work with progressor.
For full implementation see (Tindeq Progreessor Softwares) folder
"""

import platform
import logging
import asyncio
import struct
import csv
import time
import datetime

""" Copy and add required data lists from data.dart inside dataList = [] """
dataList = []

myData = [bytearray(d) for d in dataList]

RES_CMD_RESPONSE = 0
RES_WEIGHT_MEAS = 1
RES_RFD_PEAK = 2
RES_RFD_PEAK_SERIES = 3
RES_LOW_PWR_WARNING = 4

current_cmd_request = 1

def notification_handler(data):
    try:
        if data[0] == RES_WEIGHT_MEAS:
            # print("Payload size : {0}".format(data[1]))
            value = [data[i:i+4] for i in range (2, len(data), 8)]
            timestamp = [data[i:i+4] for i in range (6, len(data), 8)]
            for x, y in zip(value,timestamp):
                weight, = struct.unpack('<f', x) # <little endian ffloat
                useconds, = struct.unpack('<I', y) # <little endian unsigned int
                # print(weight, useconds)
        # elif data[0] == RES_LOW_PWR_WARNING:
        #     print("Received low battery warning.")

        # elif data[0] == RES_CMD_RESPONSE:

        #     if current_cmd_request == CMD_GET_APP_VERSION:
        #         print("---Device information---")
        #         print("FW version : {0}".format(data[2:].decode("utf-8")))

        #     elif current_cmd_request == CMD_GET_BATTERY_VOLTAGE:
        #         vdd, = struct.unpack('<I', data[2:])
        #         print("Battery voltage : {0} [mV]".format(vdd))

        #     elif current_cmd_request == CMD_GET_ERROR_INFORMATION:
        #         try:
        #             print("Crashlog : {0}".format(data[2:].decode("utf-8")))
        #             print("------------------------")
        #         except Exception as e:
        #             print("Empty crashlog")
        #             print("------------------------")
    except Exception as e:
        print(e)


if __name__ == "__main__":
    for i in myData:
        notification_handler(i)
