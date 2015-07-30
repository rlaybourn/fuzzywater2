
import numpy as np
import sys
import time
import cmanager
import csv
import paths

#basepath = "/var/www/"

def Htheta(thetas,x):
	total = 0
	px = x
	coefs = thetas[1:] #remove constant term
	for val in coefs:
		total = total + (val * px )
		px = px * x
	return total + thetas[0] #add constant term

x = np.array( [0.08,0.67,0.82,1.1,1.42,1.58,2.0,2.19,2.5,2.7])
y = np.array( [0,5.6,8.1,13.5,20.0,25.4,35.0,40.0,45.0,50.0])
p =  np.polyfit(x,y,6)
theta = [2.497237134237162, 3.1272141051382456, 3.76424478871247, 3.492216475657672, -1.0697925500533265]



repeats = 10
thisbee =  cmanager.beemanager('/dev/ttyUSB0',2)

with open(paths.basepath + "nodelist","r") as nodfile: #read list of nodes
	nodereader = csv.reader(nodfile)
	#required = nodereader.next()
	for required in nodereader: #for each node
		response = False
		error = True
		errors = 0
		timeout = 0
		theta = [float(required[4]),float(required[5]),float(required[6]),float(required[7]),float(required[8])]
		print required
		while((error == True) and (errors < 1)):                       #try transmit unit ack recieved or failed 3 times
			error = False
			while((response == False) and (timeout < repeats)):   #try the transmission up to 10 times
				response =  thisbee.readmoisture(chr(0)+chr(int(required[1])))
				print response
				timeout = timeout + 1                       #if failed increment failed counter
				print timeout
			if(response == False):                              #if failed 10 times then set error flag and wait 
				errors =  errors + 1                        #for 10 seconds before trying again  
				time.sleep(5)
				error = True
				timeout = 0

		if((response == False) or (response < 50)):             #if there was no response then default a value      
			with open(paths.basepath + "levels" + required[0] + ".csv","r") as f:  #load file
				reader = csv.reader(f)
				thelist = []
				for row in reader:                                     #read contents
					thelist.append(row)
			
			taillist = thelist[-1]
			volts = float(taillist[2])                                        #take last entry
			with open(paths.basepath + "errors.htm",'a') as outfile:
				outfile.write("unable to read, defaulting to last value," + time.strftime("%d/%m-%H:%M")+"\n")
		else:                                      #set volts value
			volts = float(response)*0.00318

		inp = volts
		print theta
		print str(Htheta(theta,volts))
		try:
			with open(paths.basepath + "levels" + required[0] + ".csv",'a') as outfile:    #write log to file
				outfile.write(str(response.rstrip("\r\n")) + "," + str(volts) + "," +str(Htheta(theta,volts))+ "," + str(required[2]) + time.strftime(",%Y,%m,%e,%H,%M") +"\n")
		except:
		        with open(paths.basepath + "errors.htm",'a') as outfile:     #if there was a file writing problem then log it
		                outfile.write("couldnt write value" + str(volts)+ "," + time.strftime("%d/%m-%H:%M")+"\n")







