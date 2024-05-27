#line 1 "D:/ICBT/3rd Semester/Microcontrollers/1069825_5505icbtel/PIC16F877A/PIC16F877A.c"
unsigned int adc_rd;
long current_duty;

void main() {
 TRISA0_bit = 1;
 TRISC = 0;
 TRISD.B2 = 1;
 TRISB.B0 = 0;
 PORTB.B0 = 1;

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
 PORTC.F4 = 0; PORTC.F5 = 1;
 PORTC.F6 = 1; PORTC.F7 = 0;
 } else if (front_sensor_left == 1 && front_sensor_right == 0) {
 PORTC.F4 = 0; PORTC.F5 = 0;
 PORTC.F6 = 1; PORTC.F7 = 0;
 } else if (front_sensor_left == 0 && front_sensor_right == 1) {
 PORTC.F4 = 0; PORTC.F5 = 1;
 PORTC.F6 = 0; PORTC.F7 = 0;
 } else if (front_sensor_left == 1 && front_sensor_right == 1) {
 PORTC.F4 = 0; PORTC.F5 = 0;
 PORTC.F6 = 0; PORTC.F7 = 0;
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
