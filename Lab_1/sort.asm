#include "p16f84.inc" 

max_ptr equ 0x0C
ptr equ 0x0D
previous equ 0x0E
swap_tmp equ 0x0F
array_base set 0x10
count set 0xA

begin:
	bcf STATUS, RP0
	movlw count-1
	movwf max_ptr
main:
	clrf ptr
loop1:
	movf ptr, W
	addlw array_base  
	movwf FSR
	movf INDF, 0x00   
	movwf previous
	incf FSR
	movf INDF, 0x00
	subwf previous,0x00
	btfsc STATUS,C
	goto skip

swap:
	movf INDF, 0x00
	movwf swap_tmp
	movf previous, W
	movwf INDF
	decf FSR
	movf swap_tmp, W
	movwf INDF

skip:
	incf ptr, F
	movf max_ptr, 0x00
	subwf ptr, W
	btfss STATUS, C
	goto loop1

loop_end:
	btfss STATUS, Z
	goto main

	end