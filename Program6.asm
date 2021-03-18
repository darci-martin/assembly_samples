TITLE Program 6     (Program6.asm)

; Author: Darci Martin
; Last Modified: 03/15/2020
; OSU email address: martdarc@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 6                Due Date: 03/15/2020
; Description: This program accepts from the user 10 signed integers. The input is validated manually
; to confirm that the value is valid and can fit in a 32-bit register. If input is not valid, an
; error message is sent back to the user. Each valid value is stored in an array. The program then
; displays the valid values, displays the sum of the values, and displays the average of the values.

;Include Irvine library to handle input/output
INCLUDE Irvine32.inc

;Macro to prompt and get string from user.
;used example Macro from the lecture as a guide
getString MACRO userPrompt, valInput, size
	push	edx
	push	ecx
	mov		edx, userPrompt
	call	WriteString
	mov		edx, valInput
	mov		ecx, size
	call	ReadString
	pop		ecx
	pop		edx
ENDM

;Macro to display string.
;used example Macro from the lecture
displayString MACRO buffer
	push	edx
	mov		edx, buffer
	call	WriteString
	pop		edx
ENDM

;Constants 
ARRAYSIZE = 10
STRINGSIZE = 12

.data
intro_1			BYTE	"Designing Low Level I/O Procedures by Darci Martin", 0
intro_2			BYTE	"Please provide 10 signed decimal integers.",0dh,0ah 
				BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0dh,0ah 
				BYTE	"After you have finished inputting the raw numbers I will display a list",0dh,0ah
				BYTE	"of the integers, their sum, and their average value.", 0
prompt1			BYTE	"Please enter a signed number: ", 0
errorMsg		BYTE	"ERROR: You did not enter a signed number or your number was too big. ", 0
output1			BYTE	"You entered the following numbers: ", 0
commaSpace		BYTE	", ", 0
output2			BYTE	"The sum of these numbers is: ", 0
output3			BYTE	"The rounded average is: ", 0
terminate		BYTE	"Thanks for the visit!", 0
userVal			BYTE	STRINGSIZE DUP(?)	
userString		BYTE	STRINGSIZE DUP(0),0
intArray		DWORD	ARRAYSIZE DUP(?)

.code
main PROC
	push	OFFSET intro_1
	push	OFFSET intro_2
	call	intro						;introduction procedure
	call	CrLf

	push	ARRAYSIZE
	push	OFFSET intArray
	push	OFFSET errorMsg
	push	OFFSET userVal
	push	SIZEOF userVal
	push	OFFSET prompt1
	call	ReadVal						;call procedure to get values from the user

	push	SIZEOF userString
	push	OFFSET userString
	push	OFFSET commaSpace
	push	OFFSET output1
	push	ARRAYSIZE
	push	OFFSET intArray
	call	displayArray				;call procedure to display user input values

	push	SIZEOF userString
	push	OFFSET userString
	push	OFFSET output3
	push	OFFSET output2
	push	ARRAYSIZE
	push	OFFSET intArray
	call	sumAvgArray					;call procedure to output the sum and average of the array values

	push	offset terminate
	call	farewell					;exit message to user
	
	exit								;exit to operating system
main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: none
intro	PROC
	pushad							;save registers
	mov		ebp, esp

;Introduce programmer and program title
	displayString	[ebp + 40]		;address of intro1
	call	CrLf
	call	CrLf

;Displays an introduction to the program
	displayString	[ebp + 36]		;address of intro2
	call	CrLf

	popad							;restore registers
	ret		8
intro	ENDP

;Procedure to get a string from the user, validate the string and convert to a number.
; Finally the procedure stores the valid values in the passed array.
;receives: prompt, size and address of userVal, error message, size and address of array.
;returns: intArray filled with valid numeric values.
;preconditions: array must exist and constants pushed are declared
;registers changed: none
ReadVal	PROC
	pushad							;save registers
	mov		ebp, esp
	sub		esp, 4					;make space for local variable

	mov		ecx, [ebp + 56]			;counter for array
	mov		edi, [ebp + 52]			;integer array address
	mov		ebx, 10					;multiplier for values

ArrayLoop:
	push	ecx						;save loop counter before getting new value

GetValue:
	getString		[ebp + 36], [ebp + 44], [ebp + 40]

	mov		ecx, 0					;set array value up for local processing
	mov		DWORD PTR [ebp - 4], 1	;local to keep track of positive/negative

	cld								;clear the direction flag
	mov		esi, [ebp + 44]			;load the user input to esi for processing
	mov		eax, 0					;reset the eax register for processing
	lodsb							;load a byte into al register

	cmp		al, '-'					;check for leading negative sign
	jne		Positive				;check if positive
	mov		DWORD PTR [ebp - 4], -1 ;value is negative
	lodsb							;load the next byte
	jmp		NextCheck				

Positive:
	cmp		al, '+'					;check for leading positive sign
	jne		NextCheck				;assuming no leading +/-
	lodsb							;load the next byte

NextCheck:
	cmp		al, 0					;check if at end of string
	je		InputArray				;send the value back for array input
	cmp		al, 48					;check if before 48 ASCII (number 0)
	jl		Error					;error message
	cmp		al, 57					;check if greater than 57 ASCII (number 9)
	jg		Error					;error message
	jmp		Convert					;value is good, convert to decimal

Error:
	displayString	[ebp + 48]
	call	CrLf
	jmp		GetValue
	
Convert:
	sub		al, 48					;subtract 48 from ascii
	xchg	ecx, eax				;get our current value (ecx) and swap with processing value
	imul	ebx						;multiply by 10
	jo		Error					;number too large
	add		ecx, eax				;store the new value
	mov		eax, 0					;clear the register
	lodsb							;load the next byte
	jmp		NextCheck

InputArray:
	mov		eax, ecx				;move calculated value to eax for final checks
	imul	DWORD PTR [ebp - 4]		;multiply by positive or negative value
	jo		Error					;error if too large
	mov		[edi], eax				;place value in array
	add		edi, 4					;move to the next position
	pop		ecx						;restore loop counter
	dec		ecx
	cmp		ecx, 0					;check if we need to loop
	jne		ArrayLoop				;get the next array value

	mov		esp, ebp				;clean up local variable
	popad							;restore registers
	ret	24
ReadVal	ENDP

;Procedure to display the passed array
;receives: array, size of array, title to display, space for printing
;returns: none
;preconditions: array exists 
;registers changed: none
displayArray PROC
	pushad							;save registers
	mov		ebp, esp
	mov		edi, [ebp + 36]			;address of the intArray
	mov		ecx, [ebp + 40]			;value of size of the array
	mov		edx, [ebp + 44]			;title to display
	call	CrLf
	displayString	edx
	call	CrLf
	mov		edx, [ebp + 48]			;commaSpace for printing
	mov		ebx, ecx				;set up for comma needs tracking
	dec		ebx

Display:
	mov		eax, [edi]				;element to print

	push	[ebp + 56]				;size of string output
	push	[ebp + 52]				;string for output
	push	eax
	call	WriteVal

	cmp		ebx, 0					;evaluate if we need a comma
	jz		FinishLoop
	displayString	edx				;print the comma

;Go to the next loop
FinishLoop:
	add		edi, 4					;move to the next element
	dec		ebx
	loop	Display

	popad							;restore registers
	ret		24
displayArray ENDP

;Procedure to display the sum and average of the passed array
;receives: array, size of array, titles to display
;returns: none
;preconditions: array exists 
;registers changed: none
sumAvgArray PROC
	pushad							;save registers
	mov		ebp, esp
	mov		edi, [ebp + 36]			;address of the intArray
	mov		ecx, [ebp + 40]			;value of size of the array
	mov		edx, [ebp + 44]			;title to display
	call	CrLf
	displayString	edx
	mov		eax, 0					;prepare register to hold the sum

calcSum:
	add		eax, [edi]				;add all elements in array
	add		edi, 4					;move to the next element
	loop	calcSum

	push	[ebp + 56]				;size of string output
	push	[ebp + 52]				;string for output
	push	eax
	call	WriteVal				;output the sum of the array

	call	CrLf
	mov		edx, [ebp + 48]			;title to display
	displayString	edx
	cdq								;sign extend the eax register
	mov		ebx, [ebp + 40]			;value of size of the array
	idiv	ebx						;signed divide to find the average of the array

	push	[ebp + 56]				;size of string output
	push	[ebp + 52]				;string for output
	push	eax
	call	WriteVal				;output the average of the array				
	call	CrLf

	popad							;restore registers
	ret		24
sumAvgArray ENDP

;Procedure to convert a passed numeric value to a string and ouput using displayString macro.
;receives: numeric value, address of string
;returns: none
;preconditions: value is valid and string exists
;registers changed: none
WriteVal	PROC
	pushad							;save registers
	mov		ebp, esp
	sub		esp, 4					;make space for local variable
	
	mov		DWORD PTR [ebp - 4], 1	;local to keep track of positive/negative
	mov		eax, [ebp + 36]			;value to store as a string
	mov		edi, [ebp + 40]			;variable to store the value to output
	mov		ebx, 10					;prepare to divide by 10
	mov		ecx, [ebp + 44]			;size of string
	sub		ecx, 2
	add		edi, ecx				;move to end of string
	std								;set direction
	or		eax, eax				;check if value is negative
	jns		Convert					;value is not negative, can proceed
	neg		eax						;value is negative, need it positive to proceed
	mov		DWORD PTR [ebp - 4], -1	;value is negative

Convert:
	mov		edx, 0					;clear for remainder
	div		ebx
	add		edx, 48					;convert remainder to ascii
	xchg	eax, edx				;put remainder into eax for processing
	stosb							;move from al to edi
	mov		eax, edx				;move quotient back into eax
	cmp		eax, 0					;check if any remaining values
	jz		Sign					;processed all go to output
	jmp		Convert					;process the next value

Sign:
	cmp		DWORD PTR [ebp - 4], -1	;check if it needs a negative sign
	jg		Positive
	mov		BYTE PTR [edi],'-' 		;add a negative sign
	jmp		Output

Positive:
	inc		edi

Output:
	mov		edx, edi
	displayString	edx				;call displayString
	
	mov		esp, ebp				;clean up local variable
	popad							;restore registers
	ret		12
WriteVal	ENDP

;Procedure to send exit message to user
;receives: none
;returns: none
;preconditions: none
;registers changed: none
farewell PROC
	pushad							;save registers
	mov		ebp, esp

;Send exit message to the user
	call	CrLf
	call	CrLf
	displayString	[ebp + 36]
	call	CrLf

	popad							;restore registers
	ret		4
farewell ENDP


END main
