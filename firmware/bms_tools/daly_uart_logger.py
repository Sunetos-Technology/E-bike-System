import serial, time
PORT = "COM6" # adjust for your system
ser = serial.Serial(PORT, 9600, timeout=1)
frame = bytes.fromhex("A5 40 90 08 00 00 00 00 00 00 00 00 00 00 00 00")
ser.write(frame)
reply = ser.read(128)
print(reply.hex())