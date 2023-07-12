## The Progressor

- See below for the bluetooth load cell we will be building the app to interface
  with.
- We've also included the app distributed by the company that supplies the
  bluetooth load cell (Tindeq) which is built for rock climbing training as
  opposed to clinical applications like we are proposing.
- Tindeq has provided us with the API as well as a short document on how to
  interface with the progressor (see rest of files in this folder).
- [Tindeq Progressor](https://tindeq.com/product/progressor/) (Bluetooth enabled
  tensile load cell).
- Default Progressor
  [App](https://play.google.com/store/apps/details?id=com.progressor&hl=en_CA&gl=US)
  (distributed by Tindeq).

## Progressor Interfacing

- The Progressor device is utilize Bluetooth 4 (LE) to communicate.
- As the device is running on a coin cell battery, it has been tuned to use as
  little as energy as possible.
- 10 minutes after disconnect the device will sleep.
- Basic Bluetooth knowledge is a prerequisite to understand this document.

## Tools to debug the device

- Nordic Semiconductors nrfConnect is a good utility to debug connection.

## Service UUID

- The Progressor device presents one service with UUID:

```
7e4e1701-1ea6-40c9-9dcc-13d34ffead57
```

## Notification UUID

- The device reports current weight/ROF by subscribing to this UUID:

```
7e4e1701-1ea6-40c9-9dcc-13d34ffead57
```

## The payload received on notification is a TLV:

- Sample Data, access full sample [here](code/raw-data.txt) containing few
  seconds

```
[1, 120, 192, 117, 84, 60, 108, 213, 0, 0, 192, 117, 58, 60, 54, 2, 1, 0, 0, 176, 136, 58, 0, 47, 1, 0, 0, 220, 170, 59, 203, 91, 1, 0, 128, 205, 228, 59, 150, 136, 1, 0, 128, 44, 242, 59, 97, 181, 1, 0, 128, 95, 15, 60, 46, 226, 1, 0, 0, 81, 227, 59, 249, 14, 2, 0, 128, 117, 212, 187, 196, 59, 2, 0, 0, 59, 30, 188, 144, 104, 2, 0, 0, 147, 148, 187, 90, 149, 2, 0, 0, 48, 190, 57, 38, 194, 2, 0, 128, 117, 6, 60, 242, 238, 2, 0, 0, 59, 56, 59, 191, 27, 3, 0, 0, 220, 170, 59, 139, 72, 3, 0]
```

- `[1` - 1st byte is Type (here 1 = WeightMeasurement)
- `120` - 2nd byte is Length (here 120 bytes)
- `192, 117, ...]` - 3rd and following bytes is value (192 to end-of-list =
  payload)
- Every 8 bytes is a chunk of single data set as:

```
[1st-byte, 2nd-byte, 192, 117, 84, 60, 108, 213, 0, 0, ...]
```

- `192, 117, 84, 60` - First 4 bytes of data portion is time value
- `108, 213, 0, 0` - Seconf 4 bytes are the load (presure applied)
- Client responsible to perform byte to int/float conversion
- Conversion depends on

## Types

| Type identificatory (Byte) | Length (byte) | Payload |
| -------------------------- | ------------- | ------- |
| 1 (WeightMeasurement)      | 4             | Float32 |
| 2 (RateOfForceMeasurement) | 4             | Float32 |

- No notification will happen unless before the Progressor has been told to.

## Command UUID

- To start and stop measurement you have to issue a write a command to the
  Progressor on the following UUID:

```
7e4e1703-1ea6-40c9-9dcc-13d34ffead57
```

| Command                 | Int/Byte | Description                                                                                                                                                                           |
| ----------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CMD_TARE_SCALE          | 100/0x64 | Tare the load cell                                                                                                                                                                    |
| CMD_START_WEIGHT_MEAS   | 101/0x65 | Tell the load cell to start measuring. <br> Weight notification over notification UUID on TLV 1.                                                                                      |
| CMD_STOP_WEIGHT_MEAS    | 102/0x66 | Stop weight measurement                                                                                                                                                               |
| CMD_START_PEAK_RFD_MEAS | 103/0x67 | Initiate 5 seconds of rate of force. <br> Command will notify weight rapidly over notification UUID TLV 1. <br> Change in Rate Of Force will be notified over notification UUID TLV 2 |
| CMD_ENTER_SLEEP         | 110/0x6e | Put cell to sleep. <br> Device will disconnect, and will only wake up by pressing button.                                                                                             |
