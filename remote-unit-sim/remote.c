/***************************************************************************/
// remote.c
// Author: Richard Laybourn
// Date: 21st July 2015
// Summary: This is the main file containing main loop and interrupt routine
//          for slave units to be used in the irrigation controller project
//**************************************************************************

#define tendec 2
#define waterconst 0.3
#include "support.h"

char inchr;    // temp variable for recieved charachter
char inbuf[10] = {0,0,0,0,0,0,0,0,0,0};   //recieved character buffer
char procbuf[10] = {0,0,0,0,0,0,0,0,0,0}; //processing buffer
char bufpointer = 0;                      //buffer pointer
unsigned char datarequested = 0;          //flag variable indicating requested behaviour
unsigned int outputcounter = 0;           //counter indicating length of time to activate irrigation
unsigned int halfsecondscount = 0;
unsigned int wlevel = 600;


void main() {

long unsigned int analogval =0;

init();  //initialise hardware

while(1)
{

 Delay_ms(100);

 analogval = wlevel;    //simulate read value from sensor
 if(TMR1H > 200)        //add a little random variation
 {
  analogval++;
 }
 else if(TMR1H < 90)
 {
  analogval--;
 }
 processrequest(analogval);   //perform behaviour requested by command from master if recieved
 asm CLRWDT;          // clear the watchdog timer
}
}

void interrupt()
{
char inchr;

 
  if(PIR1.RCIF)          //if charachter recieved
 {
  inchr = RCREG;

  if(inchr != 10)       //if char is not a linefeed then write into buffer
  {
    inbuf[bufpointer] = inchr;
    bufpointer ++;
    if(bufpointer > 9)
    {
     bufpointer = 9;
    }
  }
  else                 //if char is a linefeed then process the buffer and clear
  {
   if(inbuf[0] == 't')     //if moisture level requeted
     datarequested = 2;    //set transmit moisture level action flag
   else if(inbuf[0] == 'w')   //if watering commanded
   {
       strncpy(&procbuf,&inbuf[1],strlen(inbuf) ); //copy all except first char to procbuf
       procbuf[bufpointer-1] = 0;                  //add null string ending to procbuf
       outputcounter = atoi(procbuf);             //convert value to integer and put in outputcounter
       wlevel = wlevel + ((int)outputcounter * waterconst);
       datarequested = 1;                      //set request watering action flag
   }
   else
   {
     datarequested = 3;                       //set display watering time action flag
   }
   bufpointer = 0;                         //clear buffer
  }

  PIR1.RCIF = 0;                          //clear interrupt flag

 }
 
 if(PIR1.TMR1IF)                          //if timer overflowed
 {
    TMR1H = 0x0B;                         //load timer start value
    TMR1L = 0xDC;
    
    if(outputcounter > 0)                 //decrement output counter
    {
     outputcounter = outputcounter -1;
    }
    
    halfsecondscount++;
    if(halfsecondscount > 1200)
    {
     wlevel = wlevel - tendec;
     halfsecondscount = 0;
    }
    
    PIR1.TMR1IF =0;                      //clear interrupt
 
 
 }
 
 
}

#include "support.c"