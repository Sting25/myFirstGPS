/*
  Example 17.2 "My First GPS"
  http://tronixstuff.com/tutorials > Chapter 17
  
  Based on code by Aaron Weiss of SparkFun Electronics; 
  http://bit.ly/99YnI6
  also based on code and libaries by arduiniana.org. 
  LCD Library originally added 18 Apr 2008
  by David A. Mellis
  library modified 5 Jul 2009 by Limor Fried (http://www.ladyada.net)
  and modified 25 July 2009 by David A. Mellis
   
  Thank you :)
  
  We are using the Sparkfun GPS shield and EM-406 GPS receiver module
  Make sure the switch on the GPS shield is set to UART
  
*/ 
// necessary libraries
#include <NewSoftSerial.h>
#include <TinyGPS.h>
#include <LiquidCrystal.h>

// initialize the LiquidCrystal library with the numbers of the interface pins
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

// Define which pins you will use on the Arduino to communicate with your 
// GPS. In this case, the GPS module's TX pin will connect to the 
// Arduino's RXPIN which is pin 3.
#define RXPIN 2 //   GPS TX pin connects to Arduino D0 (thankfully by default)
#define TXPIN 3 // GPS RX pin connects to Arduino D1. You could change these if making your own hardware
#define GPSBAUD 38400 // baud rate of our EM-406 GPS module. Change for your GPS module if different

// Create an instance of the TinyGPS object
TinyGPS gps;
// Initialize the NewSoftSerial library to the pins you defined above
NewSoftSerial uart_gps(RXPIN, TXPIN);


// This is where you declare prototypes for the functions that will be 
// using the TinyGPS library.
void getgps(TinyGPS &gps);

// In the setup function, you need to initialize two serial ports; the 
// standard hardware serial port (Serial()) to communicate with your 
// terminal program an another serial port (NewSoftSerial()) for your 
// GPS.
void setup()
{
  Serial.begin(38400);
   uart_gps.begin(GPSBAUD); // setup sketch for data output speed of GPS module
  // set up the LCD's number of rows and columns: 
  
  lcd.begin(16, 2);
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Chris's 1st GPS");
  lcd.setCursor(0,1);
  lcd.print("http://mol10.com");
  delay(5000);
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Waiting for lock");
}

// This is the main loop of the code. All it does is check for data on 
// the RX pin of the ardiuno, makes sure the data is valid NMEA sentences, 
// then jumps to the getgps() function.
void loop()
{
  while(uart_gps.available())     // While there is data on the RX pin...
  {
      int c = uart_gps.read();    // load the data into a variable...
      
      if(gps.encode(c))      // if there is a new valid sentence...
      {
        Serial.print(c, BYTE);
        Serial.print("There was a valid sentence");
        getgps(gps);         // then grab the data, and display on LCD
      }
  }
}

// The getgps function will get and print the values we want.
void getgps(TinyGPS &gps)
{
  // Define the variables that will be used
  float latitude, longitude;
  // Then call this function
  gps.f_get_position(&latitude, &longitude);
  // clear LCD
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Lt: "); 
  lcd.print(latitude,3); 
  lcd.setCursor(0,1); 
  lcd.print("Ln: "); 
  lcd.print(longitude,3);
  // Same goes for date and time
  int year;
  byte month, day, hour, minute, second, hundredths;
  gps.crack_datetime(&year,&month,&day,&hour,&minute,&second,&hundredths);
  // Print data and time
//  lcd.setCursor(0,2);
//  lcd.print(hour, DEC);
//  lcd.print(":");
//    if (minute<10)
//  {
//    lcd.print("0");
//    lcd.print(minute, DEC);
//  } else if (minute>=10)
//  {
//        lcd.print(minute, DEC);
//  }
//  lcd.print(":");
//  if (second<10)
//  {
//    lcd.print("0");
//    lcd.print(second, DEC);
//  } else if (second>=10)
//  {
//        lcd.print(second, DEC);
//  }
//  lcd.print(" ");
//  lcd.print(day, DEC);
//  lcd.print("/");
//  lcd.print(month, DEC);
//  lcd.print("/");
//  lcd.print(year, DEC);
//  lcd.setCursor(0,3);
//  lcd.print(gps.f_altitude());
//  lcd.print("m ");
//  lcd.print(gps.f_speed_kmph());
//  lcd.print("km/h");
  
    /* You can also have course, but I couldn't fit it on the LCD
  lcd.print("Course (degrees): "); lcd.println(gps.f_course()); 
    */
}

