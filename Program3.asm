TITLE Program 3     (Program3.asm)

; Author: Darci Martin
; Last Modified: 02/09/2020
; OSU email address: martdarc@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 3               Due Date: 02/09/2020
; Description: This program prompts the user to enter values within the ranges of [-88,-55] or [-40,-1] inclusive. 
; It continues prompting and accepting valid numbers until the user enters a non-negative number. 
; Any non-negative numbers and numbers that are not within the indicated ranges are discarded.
; The program then calculates the average (rounded integer) value of the valid numbers and outputs the following:  
; the number of valid numbers entered, the sum of valid negative numbers, the maximum valid user value,
; the minimum valid user value, and the average (rounded integer) computed above.

;Include Irvine library to handle input/output
INCLUDE Irvine32.inc

;Constants for value limits
UPPER_LIMIT_LOW = -55
LOWER_LIMIT_LOW = -88
UPPER_LIMIT_HIGH = -1
LOWER_LIMIT_HIGH = -40


.data
intro_1			BYTE	"Program 3 by Darci Martin", 0
intro_2			BYTE	"This program receives integer values from the user and outputs the sum, average, min, max and count of values", 0
prompt_1		BYTE	"Please enter your name: ", 0
userName		BYTE	33 DUP(0)	
intro_3			BYTE	"Nice to meet you, ",0
instructions	BYTE	"Please enter a number within the range of [-88,-55] or [-40,-1] inclusive.", 0
instruct2		BYTE	"When finished, enter a non-negative number to see the results",0
userPrompt		BYTE	"Enter the number: ", 0
sumValues		DWORD	?
valueCount		DWORD	0
maxValue		DWORD	-89
minValue		DWORD	0
avgValue		DWORD	?
remainder		DWORD	?
outOfRange		BYTE	"Out of range!",0
validMes1		BYTE	"You entered ",0
validMes2		BYTE	" valid numbers",0
maxMessage		BYTE	"The maximum valid number is ",0
minMessage		BYTE	"The minimum valid number is ",0
sumValid		BYTE	"The sum of your valid numbers is ",0
roundAvg		BYTE	"The rounded average of your values is ",0
noValid			BYTE	"No valid numbers were entered",0
terminate		BYTE	"See you later, ", 0

.code
main PROC

;Introduce programmer and program title
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

;Displays an introduction to the program
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf

;Get the user's name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString

;Greet the user
	mov		edx, OFFSET intro_3
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

;Display the instructions to the user
	mov		edx, OFFSET instructions
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct2
	call	WriteString
	call	CrLf

;Prompt the user for value(s), validate user input and repeat until finished
GetValues:
	mov		edx, OFFSET userPrompt
	call	WriteString
	jmp		CheckLowerRange

ErrorMessage:
	mov		edx, OFFSET outOfRange		;not in range error, prompt user again
	call	WriteString
	call	CrLf
	mov		edx, OFFSET userPrompt
	call	WriteString	

CheckLowerRange:	
	call	ReadInt
	jns		Activity					;if non-negative then exit input loop
	cmp		eax, LOWER_LIMIT_LOW		;check lower limit of lower range
	jl		ErrorMessage
	cmp		eax, UPPER_LIMIT_LOW		;check upper limit of lower range
	jg		CheckUpperRange
	cmp		eax, maxValue				;check if max value entered
	jg		KeepMax	
	cmp		eax, minValue				;check if min value entered
	jl		KeepMin	

KeepMax:
	mov		maxValue, eax				;override the max value with the new max
	cmp		eax, minValue				;compare if also a min value
	jl		KeepMin	
	jmp		ValidValues	

KeepMin:
	mov		minValue, eax				;override the min value with the new min
	jmp		ValidValues

CheckUpperRange:
	cmp		eax, LOWER_LIMIT_HIGH		;check lower limit of upper range
	jl		ErrorMessage
	cmp		eax, maxValue				;check if max value entered
	jg		KeepMax
	cmp		eax, minValue				;check if min value entered
	jl		KeepMin	

ValidValues:
	add		sumValues, eax				;value is valid, add to our accumulator
	inc		valueCount					;increase our count of valid values
	jmp		GetValues					;repeat to get the next value

;User is done entering values, program will output count, max, min, sum and calculate average
Activity:
	cmp		valueCount, 0
	jz		NoValidMessage				;no valid values entered, exit to no valid message and exit
	mov		edx, OFFSET validMes1		;output number of valid values entered
	call	WriteString
	mov		eax, valueCount
	call	WriteDec
	mov		edx, OFFSET validMes2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET maxMessage		;output the maximum valid number
	call	WriteString
	mov		eax, maxValue
	call	WriteInt
	call	CrLf
	mov		edx, OFFSET minMessage		;output the minimum valid number
	call	WriteString
	mov		eax, minValue
	call	WriteInt
	call	CrLf
	mov		edx, OFFSET sumValid		;output the sum of the valid numbers
	call	WriteString
	mov		eax, sumValues				;after output this is used to calculate the average
	call	WriteInt
	
	cdq									;sign extend to clear the edx register
	mov		ebx, valueCount
	idiv	ebx
	mov		avgValue, eax				;save the quotient
	mov		remainder, edx				;save the remainder so we can calculate for rounding

	mov		eax, valueCount				;move the valid values count into the eax register
	cdq 								;sign extend to clear the edx register
	mov		ebx, -2				
	idiv	ebx							;dividing the count in half to check the remainder
	cmp		eax, remainder				;if half of count is greater than the first remainder then round average
	jg		RoundUp
	jmp		Output						;else no need to round

RoundUp:
	dec		avgValue					;round down to the nearest whole integer

;Output the computed rounded integer average of the valid values entered
Output:
	call	CrLf
	mov		edx, OFFSET roundAvg
	call	WriteString
	mov		eax, avgValue
	call	WriteInt
	jmp		ExitMessage	

;Message if no valid values are entered
NoValidMessage:
	mov		edx, OFFSET noValid
	call	WriteString

;Send exit message to the user
ExitMessage:
	call	CrLf
	call	CrLf
	mov		edx, OFFSET terminate
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

; exit to operating system
	exit
main ENDP

END main
