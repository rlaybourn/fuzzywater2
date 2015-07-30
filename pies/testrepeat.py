import cmanager
import time

repeats = 10
thisbee =  cmanager.beemanager('/dev/ttyUSB0',2)
response = False
error = True
errors = 0
timeout = 0
while((error == True) and (errors < 3)):
	error = False
	while((response == False) and (timeout < repeats)):
		response =  thisbee.readmoisture(chr(0)+chr(1))
		print response
		timeout = timeout + 1
	if(response == False):
		errors =  errors + 1
		time.sleep(10)
		error = True
		
		

#response = False
#timeout = 0
#while((response != True) and (timeout < repeats)):
#        response = thisbee.sendwater(50)
#	print response
#        timeout = timeout + 1

#response = thisbee.sendwater(50)
#print response
#response = thisbee.readxbee()
#if(response != False):
#	print response
	#print struct.unpack(">h", response['source_addr'])[0]
#else:
#	print "timedout"


