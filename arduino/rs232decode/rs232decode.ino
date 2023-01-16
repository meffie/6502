const byte rx_pin = 31;

/* Delays for 1200 buad. */
const unsigned long bit_delay = 800UL;
const unsigned long half_bit_delay = 400UL;
long last_error_log = 0;

void setup() {
    pinMode(rx_pin, INPUT);
    Serial.begin(57600);
}

int wait_for_start() {
    int start_bit;

    delayMicroseconds(bit_delay); /* ? */
    while (1) {
        start_bit = digitalRead(rx_pin);
        if (start_bit == 0) {
            delayMicroseconds(half_bit_delay);
            return start_bit;
        }
    }
}

int read_bit() {
    int bit;

    delayMicroseconds(bit_delay);
    bit = digitalRead(rx_pin);
    return bit;
}

/*
 * Throttled frame error logging.
 */
void log_error(char *msg) {
    unsigned long now;

    now = millis();
    if ((now - last_error_log) > 1000) {
        Serial.println(msg);
        last_error_log = now;
    }
}

void loop() {
    int start_bit, stop_bit;
    int d0, d1, d2, d3, d4, d5, d6, d7;
    byte data;
    char message[32];

    start_bit = wait_for_start();
    d0 = read_bit();
    d1 = read_bit();
    d2 = read_bit();
    d3 = read_bit();
    d4 = read_bit();
    d5 = read_bit();
    d6 = read_bit();
    d7 = read_bit();
    stop_bit = read_bit();

    if (stop_bit != 1) {
        log_error("Frame error");
        return;
    }

    data = 0xff & ((d7 << 7) | (d6 << 6) | (d5 << 5) | (d4 << 4) |
                   (d3 << 3) | (d2 << 2) | (d1 << 1) | d0);

    /* Serial.println(data, HEX); */
    if (isPrintable(data)) {
        sprintf(message, "0x%02x  %c", data, data);
    } else {
        sprintf(message, "0x%02x", data);
    }
    Serial.println(message);
}
