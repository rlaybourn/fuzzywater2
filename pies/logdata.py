
import numpy as np
import sys
import time
import cmanager
import csv
import paths



def Htheta(thetas,x):
	total = 0
	px = x
	coefs = thetas[1:] #remove constant term
	for val in coefs:
		total = total + (val * px )
		px = px * x
	return total + thetas[0] #add constant term

def getvolts(required): #function to collect sensor value
	response = False #setup flag values
	error = True
	errors = 0
	timeout = 0
	theta = [float(required[4]),float(required[5]),float(required[6]),float(required[7]),float(required[8])] #read coefficients from nodelist file
	print required
	while((error == True) and (errors < 1)):                       #try transmit unit ack recieved or failed 3 times
		error = False
		while((response == False) and (timeout < repeats)):   #try the transmission up to 10 times
			response =  thisbee.readmoisture(chr(0)+chr(int(required[1])))
			print response
			timeout = timeout + 1                       #if failed increment failed counter
			print timeout
		if(response == False):                              #if failed 10 times then set error flag and wait 
			errors =  errors + 1                        #for 5 seconds before trying again  
			time.sleep(5)
			error = True
			timeout = 0

	if((response == False) or (response < 50)):             #if there was no response or impossible value then default a value      
		with open(paths.basepath + "levels" + required[0] + ".csv","r") as f:  #load file
			reader = csv.reader(f)
			thelist = []
			for row in reader:                                     #read contents
				thelist.append(row)
		
		taillist = thelist[-1]
		volts = float(taillist[1])                                        #take last entry for volts and response
		response = taillist[0]
		with open(paths.basepath + "errors.htm",'a') as outfile:
			outfile.write("unable to read, defaulting to last value," + time.strftime("%d/%m-%H:%M")+"\n")
	else:                                      #set volts value
		volts = float(response)*0.00318      #convert response to voltage
		print theta
		print str(Htheta(theta,volts))
	return volts,response,theta            #return voltage , slave response and the coefficients used fo this node



repeats = 10   #set repeats limit
thisbee =  cmanager.beemanager('/dev/ttyUSB0',2)  #create xbee manager

with open(paths.basepath + "nodelist","r") as nodfile: #read list of nodes
	nodereader = csv.reader(nodfile)
	for required in nodereader: #for each node
		volts,response,theta = getvolts(required)

		try:
			with open(paths.basepath + "levels" + required[0] + ".csv",'a') as outfile:    #write log to file
				outfile.write(str(response.rstrip("\r\n")) + "," + str(volts) + "," +str(Htheta(theta,volts))+ "," + str(required[2]) + time.strftime(",%Y,%m,%e,%H,%M") +"\n")
		except Exception,e:
			print str(e)
			with open(paths.basepath + "errors.htm",'a') as outfile:     #if there was a file writing problem then log it
				outfile.write("couldnt write value" + str(volts)+ "," + time.strftime("%d/%m-%H:%M")+"\n")







