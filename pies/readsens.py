
import numpy as np
import sys
import serial
import time

x = np.array( [0.08,0.67,0.82,1.1,1.42,1.58,2.0,2.19,2.5,2.7])
y = np.array( [0,5.6,8.1,13.5,20.0,25.4,35.0,40.0,45.0,50.0])
p =  np.polyfit(x,y,6)
ser = serial.Serial("/dev/rfcomm2",timeout=1)
time.sleep(5)
getting = True
errorcount = 0


while((getting == True) and (errorcount < 10)):
	try:
		ser.write("t\n")
		time.sleep(0.5)
		response = ser.readline()
		volts = float(response)*0.00318
		getting = False
	except:
		getting = True
		errorcount = errorcount + 1



inp = volts#float(sys.argv[1])
print(p)
print(np.polyval(p,inp))
print(response)





