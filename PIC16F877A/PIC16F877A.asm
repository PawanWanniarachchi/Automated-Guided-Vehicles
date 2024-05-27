
_main:

;PIC16F877A.c,4 :: 		void main() {
;PIC16F877A.c,5 :: 		TRISA0_bit = 1;
	BSF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
;PIC16F877A.c,6 :: 		TRISC = 0; // Set PORTC as output for motor control
	CLRF       TRISC+0
;PIC16F877A.c,7 :: 		TRISD.B2 = 1; // Set RD0 (PORTD.B0) as input for IR sensor
	BSF        TRISD+0, 2
;PIC16F877A.c,8 :: 		TRISB.B0 = 0; // Set RB0 as output for LED
	BCF        TRISB+0, 0
;PIC16F877A.c,9 :: 		PORTB.B0 = 1; // Turn on LED initially
	BSF        PORTB+0, 0
;PIC16F877A.c,11 :: 		PWM1_Init(1000);
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      124
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;PIC16F877A.c,12 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;PIC16F877A.c,13 :: 		ADC_Init();
	CALL       _ADC_Init+0
;PIC16F877A.c,15 :: 		while(1) {
L_main0:
;PIC16F877A.c,16 :: 		int load_detected = PORTD.F0;
	MOVLW      0
	BTFSC      PORTD+0, 0
	MOVLW      1
	MOVWF      main_load_detected_L1+0
	CLRF       main_load_detected_L1+1
;PIC16F877A.c,17 :: 		int front_sensor_left = PORTD.F1;
	MOVLW      0
	BTFSC      PORTD+0, 1
	MOVLW      1
	MOVWF      main_front_sensor_left_L1+0
	CLRF       main_front_sensor_left_L1+1
;PIC16F877A.c,18 :: 		int front_sensor_right = PORTD.F2;
	MOVLW      0
	BTFSC      PORTD+0, 2
	MOVLW      1
	MOVWF      main_front_sensor_right_L1+0
	CLRF       main_front_sensor_right_L1+1
;PIC16F877A.c,19 :: 		int back_sensor_left = PORTD.F3;
	MOVLW      0
	BTFSC      PORTD+0, 3
	MOVLW      1
	MOVWF      main_back_sensor_left_L1+0
	CLRF       main_back_sensor_left_L1+1
;PIC16F877A.c,20 :: 		int back_sensor_right = PORTD.F4;
	MOVLW      0
	BTFSC      PORTD+0, 4
	MOVLW      1
	MOVWF      main_back_sensor_right_L1+0
	CLRF       main_back_sensor_right_L1+1
;PIC16F877A.c,21 :: 		int obstacle_front = PORTD.F5;
	MOVLW      0
	BTFSC      PORTD+0, 5
	MOVLW      1
	MOVWF      main_obstacle_front_L1+0
	CLRF       main_obstacle_front_L1+1
;PIC16F877A.c,22 :: 		int obstacle_back = PORTD.F6;
	MOVLW      0
	BTFSC      PORTD+0, 6
	MOVLW      1
	MOVWF      main_obstacle_back_L1+0
	CLRF       main_obstacle_back_L1+1
;PIC16F877A.c,24 :: 		adc_rd = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_rd+0
	MOVF       R0+1, 0
	MOVWF      _adc_rd+1
;PIC16F877A.c,25 :: 		current_duty = (long)adc_rd * 255;
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVLW      255
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _current_duty+0
	MOVF       R0+1, 0
	MOVWF      _current_duty+1
	MOVF       R0+2, 0
	MOVWF      _current_duty+2
	MOVF       R0+3, 0
	MOVWF      _current_duty+3
;PIC16F877A.c,26 :: 		current_duty = current_duty / 1023;
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_S+0
	MOVF       R0+0, 0
	MOVWF      _current_duty+0
	MOVF       R0+1, 0
	MOVWF      _current_duty+1
	MOVF       R0+2, 0
	MOVWF      _current_duty+2
	MOVF       R0+3, 0
	MOVWF      _current_duty+3
;PIC16F877A.c,27 :: 		PWM1_Set_Duty(current_duty);
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;PIC16F877A.c,28 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	NOP
	NOP
;PIC16F877A.c,31 :: 		if (obstacle_front == 1 || obstacle_back == 1) {
	MOVLW      0
	XORWF      main_obstacle_front_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVLW      1
	XORWF      main_obstacle_front_L1+0, 0
L__main61:
	BTFSC      STATUS+0, 2
	GOTO       L__main59
	MOVLW      0
	XORWF      main_obstacle_back_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVLW      1
	XORWF      main_obstacle_back_L1+0, 0
L__main62:
	BTFSC      STATUS+0, 2
	GOTO       L__main59
	GOTO       L_main5
L__main59:
;PIC16F877A.c,32 :: 		PORTC.F4 = 0; PORTC.F5 = 0;
	BCF        PORTC+0, 4
	BCF        PORTC+0, 5
;PIC16F877A.c,33 :: 		PORTC.F6 = 0; PORTC.F7 = 0;
	BCF        PORTC+0, 6
	BCF        PORTC+0, 7
;PIC16F877A.c,34 :: 		while (1) {
L_main6:
;PIC16F877A.c,35 :: 		PORTC.F3 = 1;
	BSF        PORTC+0, 3
;PIC16F877A.c,36 :: 		delay_ms(600);
	MOVLW      7
	MOVWF      R11+0
	MOVLW      23
	MOVWF      R12+0
	MOVLW      106
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
;PIC16F877A.c,37 :: 		PORTC.F3 = 0;
	BCF        PORTC+0, 3
;PIC16F877A.c,38 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
;PIC16F877A.c,39 :: 		PORTC.F3 = 1;
	BSF        PORTC+0, 3
;PIC16F877A.c,40 :: 		delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
	NOP
;PIC16F877A.c,41 :: 		PORTC.F3 = 0;
	BCF        PORTC+0, 3
;PIC16F877A.c,42 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
	NOP
;PIC16F877A.c,44 :: 		if (obstacle_front == 0 || obstacle_back == 0) {
	MOVLW      0
	XORWF      main_obstacle_front_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main63
	MOVLW      0
	XORWF      main_obstacle_front_L1+0, 0
L__main63:
	BTFSC      STATUS+0, 2
	GOTO       L__main58
	MOVLW      0
	XORWF      main_obstacle_back_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main64
	MOVLW      0
	XORWF      main_obstacle_back_L1+0, 0
L__main64:
	BTFSC      STATUS+0, 2
	GOTO       L__main58
	GOTO       L_main14
L__main58:
;PIC16F877A.c,45 :: 		break;
	GOTO       L_main7
;PIC16F877A.c,46 :: 		}
L_main14:
;PIC16F877A.c,47 :: 		}
	GOTO       L_main6
L_main7:
;PIC16F877A.c,48 :: 		} else {
	GOTO       L_main15
L_main5:
;PIC16F877A.c,49 :: 		if (load_detected == 1) {
	MOVLW      0
	XORWF      main_load_detected_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main65
	MOVLW      1
	XORWF      main_load_detected_L1+0, 0
L__main65:
	BTFSS      STATUS+0, 2
	GOTO       L_main16
;PIC16F877A.c,50 :: 		if (front_sensor_left == 0 && front_sensor_right == 0) {
	MOVLW      0
	XORWF      main_front_sensor_left_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main66
	MOVLW      0
	XORWF      main_front_sensor_left_L1+0, 0
L__main66:
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	MOVLW      0
	XORWF      main_front_sensor_right_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVLW      0
	XORWF      main_front_sensor_right_L1+0, 0
L__main67:
	BTFSS      STATUS+0, 2
	GOTO       L_main19
L__main57:
;PIC16F877A.c,51 :: 		PORTC.F4 = 0; PORTC.F5 = 1; // Motor 1 forward
	BCF        PORTC+0, 4
	BSF        PORTC+0, 5
;PIC16F877A.c,52 :: 		PORTC.F6 = 1; PORTC.F7 = 0; // Motor 2 forward
	BSF        PORTC+0, 6
	BCF        PORTC+0, 7
;PIC16F877A.c,53 :: 		} else if (front_sensor_left == 1 && front_sensor_right == 0) {
	GOTO       L_main20
L_main19:
	MOVLW      0
	XORWF      main_front_sensor_left_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVLW      1
	XORWF      main_front_sensor_left_L1+0, 0
L__main68:
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	MOVLW      0
	XORWF      main_front_sensor_right_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main69
	MOVLW      0
	XORWF      main_front_sensor_right_L1+0, 0
L__main69:
	BTFSS      STATUS+0, 2
	GOTO       L_main23
L__main56:
;PIC16F877A.c,54 :: 		PORTC.F4 = 0; PORTC.F5 = 0; // Motor 1 stop
	BCF        PORTC+0, 4
	BCF        PORTC+0, 5
;PIC16F877A.c,55 :: 		PORTC.F6 = 1; PORTC.F7 = 0; // Motor 2 forward
	BSF        PORTC+0, 6
	BCF        PORTC+0, 7
;PIC16F877A.c,56 :: 		} else if (front_sensor_left == 0 && front_sensor_right == 1) {
	GOTO       L_main24
L_main23:
	MOVLW      0
	XORWF      main_front_sensor_left_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main70
	MOVLW      0
	XORWF      main_front_sensor_left_L1+0, 0
L__main70:
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	MOVLW      0
	XORWF      main_front_sensor_right_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVLW      1
	XORWF      main_front_sensor_right_L1+0, 0
L__main71:
	BTFSS      STATUS+0, 2
	GOTO       L_main27
L__main55:
;PIC16F877A.c,57 :: 		PORTC.F4 = 0; PORTC.F5 = 1; // Motor 1 forward
	BCF        PORTC+0, 4
	BSF        PORTC+0, 5
;PIC16F877A.c,58 :: 		PORTC.F6 = 0; PORTC.F7 = 0; // Motor 2 stop
	BCF        PORTC+0, 6
	BCF        PORTC+0, 7
;PIC16F877A.c,59 :: 		} else if (front_sensor_left == 1 && front_sensor_right == 1) {
	GOTO       L_main28
L_main27:
	MOVLW      0
	XORWF      main_front_sensor_left_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVLW      1
	XORWF      main_front_sensor_left_L1+0, 0
L__main72:
	BTFSS      STATUS+0, 2
	GOTO       L_main31
	MOVLW      0
	XORWF      main_front_sensor_right_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVLW      1
	XORWF      main_front_sensor_right_L1+0, 0
L__main73:
	BTFSS      STATUS+0, 2
	GOTO       L_main31
L__main54:
;PIC16F877A.c,60 :: 		PORTC.F4 = 0; PORTC.F5 = 0; // Motor 1 stop
	BCF        PORTC+0, 4
	BCF        PORTC+0, 5
;PIC16F877A.c,61 :: 		PORTC.F6 = 0; PORTC.F7 = 0; // Motor 2 stop
	BCF        PORTC+0, 6
	BCF        PORTC+0, 7
;PIC16F877A.c,62 :: 		delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main32:
	DECFSZ     R13+0, 1
	GOTO       L_main32
	DECFSZ     R12+0, 1
	GOTO       L_main32
	DECFSZ     R11+0, 1
	GOTO       L_main32
	NOP
;PIC16F877A.c,63 :: 		}
L_main31:
L_main28:
L_main24:
L_main20:
;PIC16F877A.c,64 :: 		} else {
	GOTO       L_main33
L_main16:
;PIC16F877A.c,65 :: 		if (back_sensor_left == 0 && back_sensor_right == 0) {
	MOVLW      0
	XORWF      main_back_sensor_left_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVLW      0
	XORWF      main_back_sensor_left_L1+0, 0
L__main74:
	BTFSS      STATUS+0, 2
	GOTO       L_main36
	MOVLW      0
	XORWF      main_back_sensor_right_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVLW      0
	XORWF      main_back_sensor_right_L1+0, 0
L__main75:
	BTFSS      STATUS+0, 2
	GOTO       L_main36
L__main53:
;PIC16F877A.c,66 :: 		PORTC.F4 = 1; PORTC.F5 = 0;
	BSF        PORTC+0, 4
	BCF        PORTC+0, 5
;PIC16F877A.c,67 :: 		PORTC.F6 = 0; PORTC.F7 = 1;
	BCF        PORTC+0, 6
	BSF        PORTC+0, 7
;PIC16F877A.c,68 :: 		} else if (back_sensor_left == 1 && back_sensor_right == 0) {
	GOTO       L_main37
L_main36:
	MOVLW      0
	XORWF      main_back_sensor_left_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVLW      1
	XORWF      main_back_sensor_left_L1+0, 0
L__main76:
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	MOVLW      0
	XORWF      main_back_sensor_right_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVLW      0
	XORWF      main_back_sensor_right_L1+0, 0
L__main77:
	BTFSS      STATUS+0, 2
	GOTO       L_main40
L__main52:
;PIC16F877A.c,69 :: 		PORTC.F4 = 0; PORTC.F5 = 0;
	BCF        PORTC+0, 4
	BCF        PORTC+0, 5
;PIC16F877A.c,70 :: 		PORTC.F6 = 0; PORTC.F7 = 1;
	BCF        PORTC+0, 6
	BSF        PORTC+0, 7
;PIC16F877A.c,71 :: 		} else if (back_sensor_left == 0 && back_sensor_right == 1) {
	GOTO       L_main41
L_main40:
	MOVLW      0
	XORWF      main_back_sensor_left_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVLW      0
	XORWF      main_back_sensor_left_L1+0, 0
L__main78:
	BTFSS      STATUS+0, 2
	GOTO       L_main44
	MOVLW      0
	XORWF      main_back_sensor_right_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVLW      1
	XORWF      main_back_sensor_right_L1+0, 0
L__main79:
	BTFSS      STATUS+0, 2
	GOTO       L_main44
L__main51:
;PIC16F877A.c,72 :: 		PORTC.F4 = 1; PORTC.F5 = 0;
	BSF        PORTC+0, 4
	BCF        PORTC+0, 5
;PIC16F877A.c,73 :: 		PORTC.F6 = 0; PORTC.F7 = 0;
	BCF        PORTC+0, 6
	BCF        PORTC+0, 7
;PIC16F877A.c,74 :: 		} else if (back_sensor_left == 1 && back_sensor_right == 1) {
	GOTO       L_main45
L_main44:
	MOVLW      0
	XORWF      main_back_sensor_left_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVLW      1
	XORWF      main_back_sensor_left_L1+0, 0
L__main80:
	BTFSS      STATUS+0, 2
	GOTO       L_main48
	MOVLW      0
	XORWF      main_back_sensor_right_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVLW      1
	XORWF      main_back_sensor_right_L1+0, 0
L__main81:
	BTFSS      STATUS+0, 2
	GOTO       L_main48
L__main50:
;PIC16F877A.c,75 :: 		PORTC.F4 = 0; PORTC.F5 = 0;
	BCF        PORTC+0, 4
	BCF        PORTC+0, 5
;PIC16F877A.c,76 :: 		PORTC.F6 = 0; PORTC.F7 = 0;
	BCF        PORTC+0, 6
	BCF        PORTC+0, 7
;PIC16F877A.c,77 :: 		delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main49:
	DECFSZ     R13+0, 1
	GOTO       L_main49
	DECFSZ     R12+0, 1
	GOTO       L_main49
	DECFSZ     R11+0, 1
	GOTO       L_main49
	NOP
;PIC16F877A.c,78 :: 		}
L_main48:
L_main45:
L_main41:
L_main37:
;PIC16F877A.c,79 :: 		}
L_main33:
;PIC16F877A.c,80 :: 		}
L_main15:
;PIC16F877A.c,81 :: 		}
	GOTO       L_main0
;PIC16F877A.c,82 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
