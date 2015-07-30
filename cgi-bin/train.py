#!/usr/bin/python
import math
import numpy as np
import cgi
import time
import cgitb; cgitb.enable()


def Htheta(thetas,x):
	total = 0
	px = x
	coefs = thetas[1:] #remove constant term
	for val in coefs:
		total = total + (val * px )
		px = px * x
	return total + thetas[0] #add constant term

def toterr(thetas,x,y):
	total = 0
	counter = 0
	for val in x:
		#print str(val) + "  " + str(y[counter])
		#print(y[counter] - Htheta(thetas,val))
		total = total + (y[counter] - Htheta(thetas,val))
		counter+=1
	return total
def meansqerr(thetas,x,y):
	total = 0
	counter = 0
	for val in x:
		#print str(val) + "  " + str(y[counter])
		#print(y[counter] - Htheta(thetas,val))
		total = total + math.pow((y[counter] - Htheta(thetas,val)),2)
		counter+=1
	total = total / len(x)
	return total

def maxerr(thetas,x,y):
	tempval = 0
	maxval = 0
	counter = 0
	for val in x:
		tempval = y[counter] - Htheta(thetas,val)
		if(tempval > maxval):
			maxval = tempval
		counter +=1
	return maxval

def fittoply2(x,y):
	counter = 0
	erroroccured = False
	theta = [1,1,1,1,1]
	newth = [0,0,0,0,0]
	rate = 10.0 * (10**(len(theta) * -1))
	thiserr = 9999
	lasterr = 10000	
	imporoves = 0
	interations = 0
	while(imporoves < 4000):
		interations += 1
		for j in range(len(theta)):
			counter = 0
			for val in x:
				newth[j] +=  rate * ((y[counter] - Htheta(theta,val)) * math.pow(val,j)  )
				counter += 1
		for j in range(len(theta)):
			theta[j] = theta[j] + newth[j]
			newth[j] = 0
		lasterr = thiserr
		thiserr = toterr(theta,x,y)
		if(abs(thiserr) < 0.1):
			rate = 0.5 * (10**(len(theta) * -1))

		if(abs(thiserr) >= abs(lasterr)):
			imporoves = imporoves +1
		else:
			imporoves = 0

		if( thiserr != thiserr):
			imporoves = 10000

	return [theta,interations]




#x = [0.82,1.1,1.42,1.58,2.0,2.19,2.3,2.5,2.7]
#y = [8.3,13.5,20.0,23.5,35.0,40.0,43.0,46.0,50.0]

x = []
y = []

print "Content-Type: text/html"
print
print """\
<html>
<body>
<h2>Calibratiion report</h2>"""


form = cgi.FieldStorage() # instantiate only once!
for j in range(1,11):
	try:
		i = float(form.getfirst('x' + str(j)))
		if (i > 0):
			x.append(float(form.getfirst('x' + str(j))))
			y.append(float(form.getfirst('y' + str(j))))
	except:
		print "x or y "+ str(j) + " is not numeric"

whichnode = form.getfirst('node')
learningrate = form.getfirst('lrate')


theta, interations = fittoply2(x,y)


print " <form method='post' action='/cgi-bin/write.py'> "
counter = 0
for val in theta:
	print "<input type='text' name='name' Id='t" + str(counter)   + "' value='" + str(val) + "'> , "
	counter = counter +1

print "</form>"
print "<button value='write' onclick='writedata();'>Write</button>"
print "<br>"
print """</body> </html>"""

