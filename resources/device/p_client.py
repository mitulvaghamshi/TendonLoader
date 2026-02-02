#!/usr/bin/env python3

import platform
import logging
import asyncio
import struct
import csv
import time
import datetime

import matplotlib
import matplotlib.pyplot as plt
import numpy as np

from bleak import BleakClient
from bleak import discover
from bleak import _logger as logger


TARGET_NAME = "Progressor"

CMD_TARE_SCALE = 100
CMD_START_WEIGHT_MEAS = 101
CMD_STOP_WEIGHT_MEAS = 102
CMD_START_PEAK_RFD_MEAS = 103
CMD_START_PEAK_RFD_MEAS_SERIES = 104
CMD_ADD_CALIBRATION_POINT = 105
CMD_SAVE_CALIBRATION = 106
CMD_GET_APP_VERSION = 107
CMD_GET_ERROR_INFORMATION = 108
CMD_CLR_ERROR_INFORMATION = 109
CMD_ENTER_SLEEP = 110

RES_CMD_RESPONSE = 0
RES_WEIGHT_MEAS = 1
RES_RFD_PEAK = 2
RES_RFD_PEAK_SERIES = 3
RES_LOW_PWR_WARNING = 4

progressor_uuids = {
    "7e4e1701-1ea6-40c9-9dcc-13d34ffead57": "Progressor Service",
    "7e4e1702-1ea6-40c9-9dcc-13d34ffead57": "Data",
    "7e4e1703-1ea6-40c9-9dcc-13d34ffead57": "Control point",
}

progressor_uuids = {v: k for k, v in progressor_uuids.items()}

PROGRESSOR_SERVICE_UUID = "{}".format(
    progressor_uuids.get("Progressor Service")
)
DATA_CHAR_UUID = "{}".format(
    progressor_uuids.get("Data")
)
CTRL_POINT_CHAR_UUID = "{}".format(
    progressor_uuids.get("Control point")
)

csv_filename = None
csv_tags = {"weight" : None,
            "time" : None}
start_time = None


def plot_measurments():
    global csv_filename

    time = []
    weight = []

    if csv_filename is not None:
        with open(csv_filename, 'r') as csvfile:
            plots = csv.reader(csvfile, delimiter=',')
            for row in plots:
                try:
                    time.append(float(row[1]))
                    weight.append(float(row[0]))
                except Exception as e:
                    print(e)
        plt.plot(time, weight)
        plt.xlabel('Time [S]')
        plt.ylabel('Weight [Kg]')
        plt.title('Measurements')
        plt.grid()
        plt.show()

def csv_create():

    ts = time.time()
    global csv_filename
    csv_filename = "measurements_" + \
        datetime.datetime.fromtimestamp(
            ts).strftime('%Y-%m-%d_%H-%M-%S')+'.csv'
    with open(csv_filename, 'a', newline='') as csvfile:
        logwrite = csv.DictWriter(csvfile, csv_tags.keys())
        logwrite.writeheader()


def csv_write(value):
    global csv_filename
    global start_time
    ts = time.time()
    if start_time is None:
        start_time = ts
    time_s = (ts - start_time)
    csv_tags['weight'] = "{0:.3f}".format(value)
    csv_tags['time'] = time_s
    print(csv_tags)
    try:
        with open(csv_filename, 'a', newline='') as csvfile:
            logwrite = csv.DictWriter(csvfile, csv_tags.keys())
            logwrite.writerow(csv_tags)
    except Exception as e:
        print(e)


def notification_handler(sender, data):
    """ Function for handling data from the Progressor """
    try:
        if data[0] == RES_WEIGHT_MEAS:
            # offset by 2 bytes to ignore T and L in TLV
            value, = struct.unpack('<f', data[2:])
            # Log measurements to csv file
            csv_write(value)
        elif data[0] == RES_LOW_PWR_WARNING:
            print("Received low battery warning.")
    except Exception as e:
        print(e)


async def run(loop, debug=False):
    if debug:
        import sys

        # loop.set_debug(True)
        #l = logging.getLogger("bleak")
        # l.setLevel(logging.DEBUG)
        #h = logging.StreamHandler(sys.stdout)
        # h.setLevel(logging.DEBUG)
        # l.addHandler(h)

    devices = await discover()
    for d in devices:
        if d.name[:len(TARGET_NAME)] == TARGET_NAME:
            address = d.address
            print("Found \"{0}\" with address {1}".format(d.name, d.address))
            break

    async with BleakClient(address, loop=loop) as client:
        x = await client.is_connected()
        csv_create()
        print("Connected: {0}".format(x))

        await client.start_notify(DATA_CHAR_UUID, notification_handler)
        await client.write_gatt_char(CTRL_POINT_CHAR_UUID, [CMD_START_WEIGHT_MEAS])
        await asyncio.sleep(10.0, loop=loop)
        await client.write_gatt_char(CTRL_POINT_CHAR_UUID, [CMD_ENTER_SLEEP])


if __name__ == "__main__":

    loop = asyncio.get_event_loop()
    loop.run_until_complete(run(loop, False))
    plot_measurments()
