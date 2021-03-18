TITLE Program 2     (Program2.asm)

; Author: Darci Martin
; Last Modified: 01/25/2020
; OSU email address: martdarc@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 2               Due Date: 01/26/2020
; Description: This program will introduce the programmer then get the user's name and greet them. The user will then be asked to enter a number
;	representing the number of Fibonacci numbers they wish to display, then the program will calculate the requested values and display them.

;include Irvine library to handle input/output
INCLUDE Irvine32.inc

UPPER_LIMIT = 46
LOWER_LIMIT = 1

.data
intro_1			BYTE	"Hello, my name is Darci, and this is Programming Assignment #2", 0
prompt_1		BYTE	"Please enter your name: ", 0
userName		BYTE	33 DUP(0)	
intro_2			BYTE	"Nice to meet you, ",0
instructions	BYTE	"Please enter the number of Fibonacci numbers to display... you may enter a value between 1 and 46 ...", 0
promptFib		BYTE	"Enter the number: ", 0
valueFib		DWORD	?		
outOfRange		BYTE	"Out of range! Please enter a value between 1 and 46: ",0
tabSpace		BYTE	"     ", 0
rowCounter		DWORD	0	
terminate		BYTE	"See you later ", 0

.code
main PROC

;Introduce programmer
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

;Get the user's name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString

;Greet the user
	mov		edx, OFFSET intro_2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

;Display the instructions to the user
	mov		edx, OFFSET instructions
	call	WriteString
	call	CrLf

;Get the number of terms from the user, and validate the user input
	mov		edx, OFFSET promptFib
	call	WriteString
	jmp		CheckRange

ErrorMessage:
	mov		edx, OFFSET outOfRange
	call	WriteString
	call	CrLf
	mov		edx, OFFSET promptFib
	call	WriteString	

CheckRange:	
	call	ReadInt
	mov		valueFib, eax
	cmp		eax, LOWER_LIMIT
	jl		ErrorMessage
	cmp		eax, UPPER_LIMIT
	jg		ErrorMessage

;Calculate and display the Fibonacci sequence
;Set up the sequence
	mov		ebx, 0					;first value
	mov		eax, 1					;second value
	mov		ecx, valueFib			;used as the loop counter

FibLoop:
	call	WriteDec				;print out our current Fibonacci value
	mov		edx, OFFSET tabSpace
	call	WriteString				;print out the tab
	mov		edx, ebx				;move the first value to a register
	add		edx, eax				;add second term to the first term
	mov		ebx, eax				;update our first value
	mov		eax, edx				;place this new value in our second term	
	inc		rowCounter				;reduce row counter as we printed a value
	cmp		rowCounter, 5			;evaluate if we need a new line
	jz		NewLine					;go to NewLine if we need to reset the counter
	jnz		FinishLoop				;don't need a new line, just loop

;Print a new line and reset the rowCounter
NewLine:
	call	CrLf
	sub		rowCounter, 5

;Go to the next loop
FinishLoop:
	loop	FibLoop

;Send exit message
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
