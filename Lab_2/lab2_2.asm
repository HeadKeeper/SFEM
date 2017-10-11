#include "p16f84.inc"

; ----------- INIT VARIABLES ------------
i equ 0x0c
array_size equ 0xA
eeprom_addr equ 0x0
array_start equ 0x20
;---------------------------------------
	goto begin	
init_array: 			; --------- INIT ARRAY -----------------
	movlw array_size	
	movwf i
	movlw array_start
	movwf FSR 
i_loop:					; --------- INIT ARRAY LOOP ------------
	movf i, 0
	sublw array_size
	movwf INDF
	incf FSR, 1
	decfsz i, 1
	goto i_loop
	return
copy: 					; --------- INITIAL VALUES -------------
	bcf STATUS, RP0
	movlw array_size
	movwf i
	movlw eeprom_addr
	movwf EEADR
	movlw array_start
	movwf FSR
loop: 					
	movf INDF, W
	movwf EEDATA
	bsf STATUS, RP0
	bcf INTCON, GIE
	bsf EECON1, WREN
	movlw 0x55
	movwf EECON2
	movlw 0xAA
	movwf EECON2
	bsf EECON1, WR
	bsf INTCON, GIE
write_wait:
	btfsc EECON1, WR
	goto write_wait
	bcf EECON1, WREN
	bcf STATUS, RP0
	movf EEDATA, W
	bsf STATUS, RP0
	bsf EECON1, RD
	bcf STATUS, RP0
	incf EEADR, 1
	incf FSR, 1
	decfsz i, 1
	goto loop	

	return

begin:
	call init_array	
	call copy
	nop
	end