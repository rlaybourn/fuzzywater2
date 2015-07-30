import csv
import time
import serial
import cmanager
import numpy as np
from peach.fuzzy import *
from math import pi
import paths

#import pylab as p
def clamp(n, minn, maxn):
    return max(min(maxn, n), minn)

def getdata(nodenum):
	with open(paths.basepath + "levels" + str(nodenum) + ".csv","r") as f:  #load file
		reader = csv.reader(f)
		thelist = []
		for row in reader:                                     #read contents
			thelist.append(row)
	
	taillist = thelist[-15:]                                        #take last 15 entries
	#print taillist
	processedlist = []
	counter = 0
	for row in taillist:                                            #build numbered list
		processedlist.append( [(counter / 6.0),row[0],row[1],row[2]])
		counter = counter +1
	x = []
	y = []
	
	for row in processedlist:                                      #split into x and y values for polyfit
		x.append( float(row[0]))                                   
		y.append( float(row[3]))
	p =  np.polyfit(x,y,1)                                         #find gradient
	gradient = p[0]
	level = processedlist[-1][3]
	return [gradient,level]                                        #return level and gradient


def process(node , rate , level, target):                                      
	with open(paths.basepath + "node" + str(node) + "sets","r") as csvfile:    #open node settings file
		spamreader =  csv.reader(csvfile)	                          
		row  = spamreader.next()
 
		verydry = Trapezoid(row[0], row[1],row[2],row[3])              #read settings into membership functions
		row  = spamreader.next()

		bitdry = Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		ok = Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		bitwet = Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		verywet = Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		wetter = Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		stable = Triangle(row[0], row[1],row[2])
		row  = spamreader.next()

		drier =  Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		superdry = Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		none =  Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		alittle =  Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		medium =  Trapezoid(row[0], row[1],row[2],row[3])
		row  = spamreader.next()

		alot =  Trapezoid(row[0], row[1],row[2],row[3])

	yrange = numpy.linspace(-30.0, 30.0, 5000)                        #establish input range
	c = Controller(yrange,[],Centroid)	                           #create controller
	c.add_table([wetter,stable,drier,superdry],[verydry,bitdry,ok,bitwet,verywet], #add rules to contoller
	[[alot,alittle,none,none,none],[alot,alittle,none,none,none],[alot,alittle,none,none,none],[alot,medium,alittle,none,none]])
	return(c(float(rate * -1 ),float(level) - float(target)))                 #return output value

def calcwater(nodeadd,amount,area,slope,intercept):
	towater = amount * area *1000
	p = [slope,intercept]
	timetoout = (np.polyval(p,towater))
	timetoout = clamp(timetoout,0,200) 
	print towater
	print int(timetoout)
	return int(timetoout)

def sendwater(node,wtime,rate):
	xbee = cmanager.beemanager("/dev/ttyUSB0",4)
	ran = False
	errcount = 0
	#print chr(0) + chr(int(node))
	while((ran != True) and (errcount < 10)):
		response = xbee.sendwater((wtime * 2),chr(0) + chr(int(node)))
		if(response != "no reply"):
			ran = True
		else:
			errcount = errcount + 1
		print response
		with open(paths.basepath + "wlog.htm", 'a') as logfile:
			logfile.write(time.strftime("%d/%m-%H:%M") + "," + str(node) + "," + str(wtime) + "," + str(rate)+ "," + str(response) + "\n")
		


with open(paths.basepath + "nodelist","r") as nodfile:
	nodereader = csv.reader(nodfile)
	for row in nodereader: 
		targetlevel = int(row[2])
		nodenum = int(row[0])
		nodeaddress = int(row[1])
		area = float(row[3])
		situation =  getdata(nodenum)
		print situation
		print targetlevel
		action = process(nodenum,situation[0],situation[1],targetlevel)
		print action
		watertime = calcwater(nodenum,action,area,1.42,-9.5)
		print watertime
		if(watertime > 0):
			print "watering"
			sendwater(nodeaddress,watertime,situation[0])
		else:
			print "no water needed"
