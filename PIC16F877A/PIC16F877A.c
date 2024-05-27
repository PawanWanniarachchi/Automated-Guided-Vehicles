unsigned int adc_rd;
long current_duty;

void main() {
    TRISA0_bit = 1;
    TRISC = 0; // Set PORTC as output for motor control
    TRISD.B2 = 1; // Set RD0 (PORTD.B0) as input for IR sensor
    TRISB.B0 = 0; // Set RB0 as output for LED
    PORTB.B0 = 1; // Turn on LED initially

    PWM1_Init(1000);
    PWM1_Start();
    ADC_Init();

    while(1) {
        int load_detected = PORTD.F0;
        int front_sensor_left = PORTD.F1;
        int front_sensor_right = PORTD.F2;
        int back_sensor_left = PORTD.F3;
        int back_sensor_right = PORTD.F4;
        int obstacle_front = PORTD.F5;
        int obstacle_back = PORTD.F6;

        adc_rd = ADC_Read(0);
        current_duty = (long)adc_rd * 255;
        current_duty = current_duty / 1023;
        PWM1_Set_Duty(current_duty);
        delay_ms(5);

        // Check the state of the IR sensor
        if (obstacle_front == 1 || obstacle_back == 1) {
            PORTC.F4 = 0; PORTC.F5 = 0;
            PORTC.F6 = 0; PORTC.F7 = 0;
            while (1) {
                PORTC.F3 = 1;
                delay_ms(600);
                PORTC.F3 = 0;
                delay_ms(100);
                PORTC.F3 = 1;
                delay_ms(300);
                PORTC.F3 = 0;
                delay_ms(100);

                if (obstacle_front == 0 || obstacle_back == 0) {
                    break;
                }
            }
        } else {
            if (load_detected == 1) {
                if (front_sensor_left == 0 && front_sensor_right == 0) {
                    PORTC.F4 = 0; PORTC.F5 = 1; // Motor 1 forward
                    PORTC.F6 = 1; PORTC.F7 = 0; // Motor 2 forward
                } else if (front_sensor_left == 1 && front_sensor_right == 0) {
                    PORTC.F4 = 0; PORTC.F5 = 0; // Motor 1 stop
                    PORTC.F6 = 1; PORTC.F7 = 0; // Motor 2 forward
                } else if (front_sensor_left == 0 && front_sensor_right == 1) {
                    PORTC.F4 = 0; PORTC.F5 = 1; // Motor 1 forward
                    PORTC.F6 = 0; PORTC.F7 = 0; // Motor 2 stop
                } else if (front_sensor_left == 1 && front_sensor_right == 1) {
                    PORTC.F4 = 0; PORTC.F5 = 0; // Motor 1 stop
                    PORTC.F6 = 0; PORTC.F7 = 0; // Motor 2 stop
                    delay_ms(2000);
                }
            } else {
                if (back_sensor_left == 0 && back_sensor_right == 0) {
                    PORTC.F4 = 1; PORTC.F5 = 0;
                    PORTC.F6 = 0; PORTC.F7 = 1;
                } else if (back_sensor_left == 1 && back_sensor_right == 0) {
                    PORTC.F4 = 0; PORTC.F5 = 0;
                    PORTC.F6 = 0; PORTC.F7 = 1;
                } else if (back_sensor_left == 0 && back_sensor_right == 1) {
                    PORTC.F4 = 1; PORTC.F5 = 0;
                    PORTC.F6 = 0; PORTC.F7 = 0;
                } else if (back_sensor_left == 1 && back_sensor_right == 1) {
                    PORTC.F4 = 0; PORTC.F5 = 0;
                    PORTC.F6 = 0; PORTC.F7 = 0;
                    delay_ms(2000);
                }
            }
        }
    }
}