from xbee import XBee
import serial
import time
import struct



class beemanager:


	def __init__(self,port,timeouttime):
		'initialise xbee manager'
		try:
			self.ser = serial.Serial(port,timeout=1)
			self.xbee = XBee(self.ser)
			self.timeout = timeouttime
		except Exception as inst:
			print type(inst)     # the exception instance
			print inst.args      # arguments stored in .args
			print inst           # __str__ allows args to be printed directly
			print "ooops something went wrong setting up"
			


	def senddata(self,addr,datain):
		'sends data to specified node address'
		sent = False
		error = False
		counter = 0
		while((sent==False) and (error==False) and (counter<5)):
			try:
				self.xbee.send('tx',frame_id='A',dest_addr=addr,data=datain)
				if(self.ser.inWaiting):
					response = self.xbee.wait_read_frame()
					if(response['status'] == '\x00'):
						sent = True

					else:
						sent = False
						counter = counter +1

			except Exception as inst:
				print type(inst)     # the exception instance
				print inst.args      # arguments stored in .args
				print inst           # __str__ allows args to be printed directly
				print "ooops something went wrong sending"
				error = True

		if((sent==False)):	
			return False
		else:
			return True



	def readxbee(self):
		'returns data and address'
		counter = 0
		while((self.ser.inWaiting() < 1) and counter <= self.timeout):
			counter = counter + 1
			time.sleep(1.0)

		if(counter > self.timeout):
			return False
		else:
			response = self.xbee.wait_read_frame()
			return (response['rf_data'],struct.unpack(">h", response['source_addr'])[0])
	
	def sendwater(self,timeval,addr):
		#print "sent: " + "w"+str(timeval) + "\n"
		self.senddata(addr,"w" +str(timeval) + "\n")
		reply = self.readxbee()
		#print "reply is:" + str(reply)
		if(reply != False):
			#print(int(reply[0]))
			#print timeval-1
			if((int(reply[0]) == timeval) or (int(reply[0]) == (timeval-1))):
				return True
			else:
				return "incorrect"
		else:
			return "no reply"


	def readmoisture(self,node):
		self.senddata(node,"t\n")
		reply = self.readxbee()
		#print reply
		if(reply != False):
			return reply[0]
		else:
			return False



	def __del__(self):
		self.ser.close()
