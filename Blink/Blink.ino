int counter = 0;
int p1 = 1;
int p2 = 99;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 13 as an output.
  pinMode(13, OUTPUT);

  // enable serial communication
  Serial.begin(9600);
  
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(13, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(100);               // wait for half a second
  digitalWrite(13, LOW);    // turn the LED off by making the voltage LOW
  delay(100);               // wait for half a second
  //counter++;
  //Serial.print(counter);
  Serial.print(p1+(p2*100));
  Serial.print("|");
}
