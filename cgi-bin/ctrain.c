//------------------------------------------------------------------------------------------
// Author: Richard Laybourn
// Date  : July 20th 2015
// summary: this program implements a CGI script that collects data from the calibraion.php page 
//          and returns a HTML table containing coefficients and a write button
//          to call the correct javascript function to write these constants into a nodes calibration
//---------------------------------------------------------------------------------------------

#include <stdio.h>
#include "cgic.h"
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "ctrainsupport.h"



int cgiMain(void)  //when using the cgic library program execution starts at cgiMain
{
char namex[30],namey[30],nameth[30];   //buffers for storing HTML posted variable names
double readit[2];                      //array to store temp x and y values
double x[10],y[10];                    //arrays to store all posted X and Ys
double error = 0;                      //total error using calculated coeffs
int count = 1;                         //interation counter
int datapointer = 0;                   //pointer variable
int sizeth,sizex;                      //size of coeffs array and X array respectively 
double thetas[] = {1,1,1,1,1};         //coeffs
double readrate = 0;                    //requested learning rate


cgiHeaderContentType ("text / html");
fprintf(cgiOut,"<HTML><BODY>\n");
fprintf(cgiOut,"<H1> Calibratiion report </H1>\n");	

datapointer = collectdata(x,y,&readrate);  //collect all posted values datapointer set equal to number of datapoints read
sizeth = sizeof(thetas)/sizeof(double);    //set sizes of arrays
sizex = datapointer;
error = fitto(thetas,x,y,sizeth,sizex,readrate);    //find coeffs and return error using those coeffs 

fprintf(cgiOut,"learning rate read %f<br>",readrate);
fprintf(cgiOut,"error level achieved %f",error);
fprintf(cgiOut,"<form method='post' action='/cgi-bin/write.py'>");  //write out html form
for(count=0;count<sizeth;count++)
{

	fprintf(cgiOut,"<input type='text' name='name' Id='t%d' value='%f'> \n",count,thetas[count]);
}
fprintf(cgiOut,"</form>");
fprintf(cgiOut,"<br><button value='write' class='nomal' onclick='writedata();'>Write</button>"); //create button to run writedata() javascript function
fprintf(cgiOut,"<br>\n");
fprintf(cgiOut,"</BODY></HTML>\n");
return 0;
}

#include "ctrainsupport.c"