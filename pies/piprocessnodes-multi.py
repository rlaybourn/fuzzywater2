import csv
import time
import serial
import numpy as np
from peach.fuzzy import *
from math import pi

#import pylab as p
def clamp(n, minn, maxn):
    return max(min(maxn, n), minn)

def getdata(nodenum):
	with open("/var/www/levels" + str(nodenum) + ".csv","r") as f:  #load file
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
	with open("/var/www/node" + str(node) + "sets","r") as csvfile:    #open node settings file
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

def processnode(node):
	state = getdata(node)
	waterout = process(node,state[0],state[1],30)
	addwater(2,waterout,0.1,1.2,-17)


#situation = getdata(1)
#print situation
with open("/var/www/nodelist","r") as nodfile:
	nodereader = csv.reader(nodfile)
	for row in nodereader:
	#row = nodereader.next()
		area = float(row[3]) 		
		targetlevel = int(row[2])
		nodenum = int(row[0])
		situation =  getdata(nodenum)
		print situation
		print targetlevel
		action = process(nodenum,situation[0],situation[1],targetlevel)
		print action
		calcwater(nodenum,action,area,1.42,-9.5)

