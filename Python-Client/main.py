import serial
import struct

def main():
    ser = serial.Serial('/dev/ttyUSB1', 115200)
    print("Serial connection made at " + str(ser.name))
    while True:
        byteInput = input("Hex FTW: ")
        x = bytes.fromhex(byteInput)
        print(x.hex(' ')) 
        ser.write(x)


if __name__ == "__main__":
    main()
