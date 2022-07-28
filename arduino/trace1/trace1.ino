/* pin numbers */
const char ADDR[] = {
  22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52  /* a15 .. a0 */
};
const char DATA[] = {
  39, 41, 43, 45, 47, 49, 51, 53 /* d7 .. d0 */
};


#define RESB 2
#define CLK  3
#define RWB  4

/* gobals */
unsigned int ticks = 0;
int traceall = 1;

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
  Serial.println();
  Serial.println("Reset");
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
  if (addr == 0xfffd) {
      ticks = 0;
  }
  char rw = digitalRead(RWB) ? 'r' : 'w';
  char ch = isPrintable(data) ? data : '.';
  sprintf(diag, "%012d %04x %c %02x %c\n", ticks++, addr, rw, data, ch);
  if (traceall || (0x0000<=addr && addr<=0x4000)) {
      Serial.print(diag);
  }
}

void loop() {
  /* empty */
}
