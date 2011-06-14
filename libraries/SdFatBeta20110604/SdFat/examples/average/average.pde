/*
 * Calculate the sum and average of a list of floating point numbers 
 */
#include <SdFat.h>

// SD chip select pin
const uint8_t chipSelect = SS_PIN;

// object for the SD file system
SdFat sd;

// define a serial output stream
ArduinoOutStream cout(Serial);
//------------------------------------------------------------------------------
void writeTestFile() {
  // open the output file
  ofstream sdout("AVG_TEST.TXT");

  // write a series of float numbers
  for (int16_t i = -1001; i < 2000; i += 13) {
    sdout << 0.1 * i << endl;
  }
  if (!sdout) sd.errorHalt("sdout failed");

  // file will be closed by destructor when sdout goes out of scope
}
//------------------------------------------------------------------------------
void calcAverage() {
  uint16_t n = 0;  // count of input numbers
  double num;      // current input number
  double sum = 0;  // sum of input numbers

  // open the input file
  ifstream sdin("AVG_TEST.TXT");

  // check for an open failure
  if (!sdin) sd.errorHalt("sdin failed");

  // read and sum the numbers
  while (sdin >> num) {
    n++;
    sum += num;
  }

  // print the results
  cout << "sum of " << n << " numbers = " << sum << endl;
  cout << "average = " << sum/n << endl;
}
//------------------------------------------------------------------------------
void setup() {
  Serial.begin(9600);

  // pstr stores strings in flash to save RAM
  cout << pstr("Type any character to start\n");
  while (!Serial.available());

  // initialize the SD card at SPI_HALF_SPEED to avoid bus errors with
  // breadboards.  use SPI_FULL_SPEED for better performance.
  if (!sd.init(SPI_HALF_SPEED, chipSelect)) sd.initErrorHalt();

  // write the test file
  writeTestFile();

  // read the test file and calculate the average
  calcAverage();
}
//------------------------------------------------------------------------------
void loop() {}
