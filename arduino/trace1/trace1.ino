/* pin numbers */
const char ADDR[] = {
  52, 50, 48, 46, 44, 42, 40, 38,
  36, 34, 32, 30, 28, 26, 24, 22
};
const char DATA[] = {
  53, 51, 49, 47, 45, 43, 41, 39
};

#define CLK  2
#define RESB 3
#define RWB  4

/* gobals */
int ticks = 0;


void setup() {
  for (int i = 0; i < 16; i++) {
    pinMode(ADDR[i], INPUT);
  }
  for (int i = 0; i < 8; i++) {
    pinMode(DATA[i], INPUT);
  }
  pinMode(CLK, INPUT);
  pinMode(RWB, INPUT);
  pinMode(RESB, INPUT);
  attachInterrupt(digitalPinToInterrupt(CLK), on_clock, RISING);
  attachInterrupt(digitalPinToInterrupt(RESB), on_reset, FALLING);
  Serial.begin(57600);
}

void on_reset() {
  ticks = 0;
  Serial.println();
  Serial.print("Reset");
  Serial.println();
}

void on_clock() {
  char diag[128];
  unsigned int addr = 0;
  unsigned int data = 0;
  for (int i = 0; i < 16; i++) {
    int bit = digitalRead(ADDR[i]) ? 1 : 0;
    addr = (addr << 1) | bit;
  }
  for (int i = 0; i < 8; i++) {
    int bit = digitalRead(DATA[i]) ? 1 : 0;
    data = (data << 1) | bit;
  }
  char rw = digitalRead(RWB) ? 'r' : 'w'; 
  sprintf(diag, "%06d %c %04x %02x\n", ticks++, rw, addr, data);
  Serial.print(diag);
}

void loop() {
  /* empty */
}
