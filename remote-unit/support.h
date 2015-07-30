//***************************************************************************
// Author: Richard Laybourn
// date:   20 June 2015
// summary: Header file containing declarations for supporting functions of
//          irrigation controller project
//
//******************************************************************************
  void Serial_display_value ( unsigned int value);
  void init();
  int readanalog();
  void processrequest(int analogval);