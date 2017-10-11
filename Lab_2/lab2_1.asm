#include "p16f84.inc"

counter equ 0x0c
array_start set 0x20
array_size set 0x5
eeprom_location set 0x0

; ---------- INITIALIZE EEPROM MEMORY --------------
org 0x2100 		; interrupt call
de 0x42			; write data to eeprom
de 0x53
de 0x55
de 0x49
de 0x52
org 0x0 		; call interrupt
;---------------------------------------------------
eeprom_read_const_data:
	clrf INTCON			; prohibition of interrupts
	movlw array_size
	movwf counter 		; move array size to counter
	movlw eeprom_location
	movwf EEADR 		; move eeprom_location to eeadr
	movlw array_start  
	movwf FSR			; move array start to fsr register
read:
	bsf STATUS, RP0		; change bank
	bsf EECON1, RD		; change eecon1 to read
	bcf STATUS, RP0		; change bank
	movf EEDATA, 0		
	movwf INDF			; write data from eeprom to array
	incf EEADR, 1 		; inc addres index in eeprom
	incf FSR, 1			; inc address in array
	decfsz counter, 1	; dec counter
	goto read
	return
	
begin:
	call eeprom_read_const_data ; call procedure
	nop
	end	



