#!/usr/bin/python
import cgi
import cgitb; cgitb.enable()
import csv
import paths

form = cgi.FieldStorage() # instantiate only once!
whichnode = form.getfirst('node')
t = []
for j in range(5):
	try:
		i = float(form.getfirst('t' + str(j)))

		t.append(form.getfirst('t' + str(j)))
	except:
		print "t"+ str(j) + " is not numeric"


with open(paths.basepath + "nodelist","r") as nodfile:
	nodereader = csv.reader(nodfile)
	outputlist = []
	for row in nodereader:
		if (row[0] != whichnode):
			outputlist.append( row[0] + "," + row[1] + "," + row[2] + "," + row[3] + "," + row[4] + "," + row[5] + "," + row[6] + "," + row[7] +"," + row[8])
		else:  
			outputlist.append( row[0] + "," + row[1] + "," + row[2] + "," + row[3] +  "," + t[0] + "," + t[1] + "," + t[2] + "," + t[3] + "," + t[4])

with open(paths.basepath + "nodelist","w") as nodfile:
	for line in outputlist:
		nodfile.write(line + "\n")

print "Content-Type: text/html"
print
print """\
<html>
<body>"""
print "<h2>Node " + str(whichnode) + "Written ok</h2>"
#print "node is " + str(whichnode) + "<br>"
#for val in t:
#	print str(val) + "<br>"

for line in outputlist:
	print line + "<br>"
print """</body>
</html>"""
