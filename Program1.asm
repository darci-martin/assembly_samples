TITLE Program 1     (Program1.asm)

; Author: Darci Martin
; Last Modified: 01/16/2020
; OSU email address: martdarc@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 1                 Due Date: 01/19/2020
; Description: This program will introduce the programmer, have the user enter three numbers in descending order, 
;	then calculate and display the sum and differences of the three numbers.

;include Irvine library to handle input/output
INCLUDE Irvine32.inc

.data
intro			BYTE	"Hello, my name is Darci, and this is Programming Assignment #1", 0
instructions	BYTE	"Please enter three numbers in descending order per the prompts and I will show the sum and differences of the values...", 0
prompt_A		BYTE	"Enter first value: ", 0
value_A			DWORD	?
prompt_B		BYTE	"Enter second value: ", 0
value_B			DWORD	?
prompt_C		BYTE	"Enter third value: ", 0
value_C			DWORD	?
plus_sign		BYTE	" + ", 0					
minus_sign		BYTE	" - ", 0					
equal_sign		BYTE	" = ", 0				
sumAB			DWORD	?
diffAB			DWORD	?
sumAC			DWORD	?
diffAC			DWORD	?
sumBC			DWORD	?
diffBC			DWORD	?
sumABC			DWORD	?
terminate		BYTE	"Thanks for stopping by!", 0

.code
main PROC

;Introduce programmer
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf

;Display the instructions to the user
	mov		edx, OFFSET instructions
	call	WriteString
	call	CrLf

;Get the data from the user
;Get the first value
	mov		edx, OFFSET prompt_A
	call	WriteString
	call	ReadInt
	mov		value_A, eax

;Get the second value
	mov		edx, OFFSET prompt_B
	call	WriteString
	call	ReadInt
	mov		value_B, eax

;Get the third value
	mov		edx, OFFSET prompt_C
	call	WriteString
	call	ReadInt
	mov		value_C, eax

;Calculate and store the values we need
;Calculate the value of A+B
	mov		eax, value_A
	add		eax, value_B
	mov		sumAB, eax

;Calculate the value of A-B
	mov		eax, value_A
	sub		eax, value_B
	mov		diffAB, eax

;Calculate the value of A+C
	mov		eax, value_A
	add		eax, value_C
	mov		sumAC, eax
	
;Calculate the value of A-C
	mov		eax, value_A
	sub		eax, value_C
	mov		diffAC, eax

;Calculate the value of B+C
	mov		eax, value_B
	add		eax, value_C
	mov		sumBC, eax
	
;Calculate the value of B-C
	mov		eax, value_B
	sub		eax, value_C
	mov		diffBC, eax
	
;Calculate the value of A+B+C
	mov		eax, value_A
	add		eax, value_B
	add		eax, value_C
	mov		sumABC, eax

;Report results back to user
;Result of A+B
	mov		eax, value_A
	call	WriteDec
	mov		edx, OFFSET plus_sign
	call	WriteString
	mov		eax, value_B
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, sumAB
	call	WriteDec
	call	CrLf
	
;Result of A-B
	mov		eax, value_A
	call	WriteDec
	mov		edx, OFFSET minus_sign
	call	WriteString
	mov		eax, value_B
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, diffAB
	call	WriteDec
	call	CrLf
	
;Result of A+C
	mov		eax, value_A
	call	WriteDec
	mov		edx, OFFSET plus_sign
	call	WriteString
	mov		eax, value_C
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, sumAC
	call	WriteDec
	call	CrLf

;Result of A-C
	mov		eax, value_A
	call	WriteDec
	mov		edx, OFFSET minus_sign
	call	WriteString
	mov		eax, value_C
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, diffAC
	call	WriteDec
	call	CrLf
	
;Result of B+C
	mov		eax, value_B
	call	WriteDec
	mov		edx, OFFSET plus_sign
	call	WriteString
	mov		eax, value_C
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, sumBC
	call	WriteDec
	call	CrLf

;Result of B-C
	mov		eax, value_B
	call	WriteDec
	mov		edx, OFFSET minus_sign
	call	WriteString
	mov		eax, value_C
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, diffBC
	call	WriteDec
	call	CrLf

;Result of A+B+C
	mov		eax, value_A
	call	WriteDec
	mov		edx, OFFSET plus_sign
	call	WriteString
	mov		eax, value_B
	call	WriteDec
	mov		edx, OFFSET plus_sign
	call	WriteString
	mov		eax, value_C
	call	WriteDec
	mov		edx, OFFSET equal_sign
	call	WriteString
	mov		eax, sumABC
	call	WriteDec
	call	CrLf

;Send exit message
	mov		edx, OFFSET terminate
	call	WriteString
	call	CrLf

; exit to operating system
	exit
main ENDP

END main
