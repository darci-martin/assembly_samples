TITLE Program 4     (Program4.asm)

; Author: Darci Martin
; Last Modified: 02/15/2020
; OSU email address: martdarc@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 4              Due Date: 02/17/2020
; Description: This program prompts the user to enter a value within the range of [1 - 400] inclusive. 
; If the user enters a value outside of the range, it will continue to prompt until receiving a value in the range.
; The program then calculates and prints composite values until it has printed the quantity of values that
; the user specified in the original input. A composite value is a value greater than 1 that is not prime.

;Include Irvine library to handle input/output
INCLUDE Irvine32.inc

;Constants for value limits
UPPER_LIMIT = 400

.data
intro_1			BYTE	"Composite Numbers by Darci Martin", 0
intro_2			BYTE	"Enter the number of composite values you would like to see.", 0
intro_3			BYTE	"Up to 400 composite values can be displayed.",0
userPrompt		BYTE	"Enter the number of composites to display (1 to 400): ", 0
userVal			DWORD	?
outOfRange		BYTE	"Out of range!",0
tabSpace		BYTE	"   ", 0
compValue		DWORD	1
rowCounter		DWORD	0
divisor			DWORD	1
terminate		BYTE	"Thanks for the visit!", 0

.code
main PROC
	call	intro					;introduction procedure
	call	getData					;procedure to get user input
	call	showComposites			;procedure to calculate and print composites
	call	farewell				;exit message to user
	
	exit							;exit to operating system
main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
intro	PROC

;Introduce programmer and program title
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	call	CrLf

;Displays an introduction to the program
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf

	ret
intro	ENDP

;Procedure to get number of composites from user
;receives: none
;returns: user input value for global variable userVal
;preconditions:  none
;registers changed: edx
getData	PROC

;Prompt the user for a value, call validation procedure
	mov		edx, OFFSET userPrompt
	call	WriteString
	call	validate

	ret
getData	ENDP

;Procedure to validate user input
;receives: none
;returns: user input value for global variable userVal
;preconditions: none
;registers changed: edx, eax
validate PROC
	jmp CheckRange

ErrorMessage:
	mov		edx, OFFSET outOfRange		;not in range error, prompt user again
	call	WriteString
	call	CrLf
	mov		edx, OFFSET userPrompt
	call	WriteString	

CheckRange:	
	call	ReadInt
	cmp		eax, 1						;check lower limit of range
	jl		ErrorMessage
	cmp		eax, UPPER_LIMIT			;check upper limit of range
	jg		ErrorMessage
	mov		userVal, eax				;value is valid
	
	ret
validate ENDP

;Procedure to calculate and output composite values
;receives: userVal global variable
;returns: none
;preconditions: user has entered a valid value for our count
;registers changed: ecx, eax
showComposites PROC

;Loop to call isComposite procedure
	mov		ecx, userVal			;used as the loop counter

CompositeLoop:
	call	isComposite				;call procedure to calculate and print composites
	cmp		rowCounter, 10			;evaluate if we need a new line
	jz		NewLine					;go to NewLine if we need to reset the counter
	jnz		FinishLoop				;don't need a new line, just loop

;Print a new line and reset the rowCounter
NewLine:
	call	CrLf
	sub		rowCounter, 10

;Go to the next loop
FinishLoop:
	loop	CompositeLoop

	ret
showComposites ENDP

;Procedure to find the next composite value to print
;receives: last printed composite value in global variable compValue
;returns: next composite value printed in global variable compValue
;preconditions: none
;registers changed: eax, ebx, edx
isComposite PROC

findNextComp:
	inc		compValue				;increment our last composite value
	mov		divisor, 1				;reset divisor for next composite

findComposite:
	inc		divisor					;increment our divisor
	mov		edx, 0					;clear the register before division
	mov		eax, compValue			;current composite value we want to test
	mov		ebx, divisor			;set divisor
	cmp		eax, ebx				;compare if equal to divisor
	jz		findNextComp			;test the next composite
	div		ebx						
	cmp		edx, 0					;check if there is a remainder
	jz		printComposite			;remainder is 0 so this is composite value
	jmp		findComposite			;continue testing the dividend
	
;Print out the values
printComposite:
	mov		eax, compValue
	call	WriteDec
	mov		edx, OFFSET tabSpace
	call	WriteString
	inc		rowCounter				;increase row counter as we printed a value
	mov		divisor, 1				;reset divisor for next composite

	ret
isComposite ENDP

;Procedure to send exit message to user
;receives: none
;returns: none
;preconditions: none
;registers changed: edx
farewell PROC

;Send exit message to the user
	call	CrLf
	call	CrLf
	mov		edx, OFFSET terminate
	call	WriteString
	call	CrLf

	ret
farewell ENDP


END main
