TITLE Program 5     (Program5.asm)

; Author: Darci Martin
; Last Modified: 03/01/2020
; OSU email address: martdarc@oregonstate.edu
; Course number/section: CS271 400
; Project Number: 5               Due Date: 03/01/2020
; Description: This program generates 200 random integers in the range of 10 to 29 inclusive. It then displays
; the array, sorts the array of numbers in ascending order, calculates and displays the median value,
; and finally it counts how many instances of each value occur and displays the counts in an array.

;Include Irvine library to handle input/output
INCLUDE Irvine32.inc

;Constants for lower bound, upper bound, size of random array, and size of count array
LO = 10
HI = 29
ARRAYSIZE = 200
COUNTSIZE = 20

.data
intro_1			BYTE	"Sorting and Counting Random Integer Arrays by Darci Martin", 0
intro_2			BYTE	"This program generates 200 random integers in the range of [10 ... 29], ",0dh,0ah 
				BYTE	"displays the array, sorts the array in ascending order, calculates and displays the median value, ",0dh,0ah 
				BYTE	"displays the sorted array, creates an array that holds the count of each instance of each value, ",0dh,0ah
				BYTE	"and finally displays the count array.", 0
randArray		DWORD	ARRAYSIZE DUP(?)
title_1			BYTE	"Unsorted random numbers: ", 0
title_2			BYTE	"List Median Value: ",0
title_3			BYTE	"Sorted random numbers: ", 0
countArray		DWORD	COUNTSIZE DUP(?)
title_4			BYTE	"Instance of each random generated number, starting with count of 10's", 0
tabSpace		BYTE	"  ", 0
terminate		BYTE	"Thanks for the visit!", 0

.code
main PROC
	call	intro						;introduction procedure

	push	LO
	push	HI
	push	ARRAYSIZE
	push	offset randArray
	call	fillArray					;procedure to fill the array

	push	offset tabSpace
	push	offset title_1
	push	ARRAYSIZE
	push	offset randArray
	call	displayList					;procedure used to display the list

	push	ARRAYSIZE
	push	offset randArray	
	call	sortList					;procedure to sort the array

	call	CrLf
	mov		edx, offset title_2			;title for median value
	call	WriteString

	push	ARRAYSIZE
	push	offset randArray
	call	displayMedian				;procedure to count and display the median value of the array

	push	offset tabSpace
	push	offset title_3
	push	ARRAYSIZE
	push	offset randArray
	call	displayList					;procedure used to display the list

	push	LO
	push	offset countArray
	push	ARRAYSIZE
	push	offset randArray
	call	countList					;procedure to count how many times each value is in the array

	push	offset tabSpace
	push	offset title_4
	push	COUNTSIZE				
	push	offset countArray		
	call	displayList					;procedure used to display the list

	call	farewell					;exit message to user
	
	exit								;exit to operating system
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

	ret
intro	ENDP

;Procedure to fill an array of integers with random values
;receives: randArray, LO, HI, ARRAYSIZE
;returns: randArray filled with random integers
;preconditions:  randArray exists and global constants declared
;registers changed: none
fillArray	PROC
	pushad							;save registers
	mov		ebp, esp
	mov		edi, [ebp + 36]			;address of the randArray
	mov		ecx, [ebp + 40]			;value of size of the array
	call	Randomize				;set seed for random values

;the following method uses the example from the lecture
Fill:
	mov		eax, [ebp + 44]			;calculate the range of values
	sub		eax, [ebp + 48]				
	inc		eax		
	call	RandomRange				;generate the random value
	add		eax, [ebp + 48]			;place in set range
	mov		[edi], eax				;place random value in array
	add		edi, 4					;move to the next position
	loop	Fill

	popad							;restore registers
	ret		16
fillArray	ENDP

;Procedure to display the passed array
;receives: array, size of array, title to display, space for printing
;returns: none
;preconditions: array exists 
;registers changed: none
displayList	PROC
	pushad							;save registers
	mov		ebp, esp
	mov		edi, [ebp + 36]			;address of the randArray
	mov		ecx, [ebp + 40]			;value of size of the array
	mov		edx, [ebp + 44]			;title to display
	call	CrLf
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 48]			;tabSpace for printing
	mov		ebx, 0					;reset row counter before display loop
Display:
	mov		eax, [edi]				;element to print
	call	WriteDec	
	call	WriteString
	inc		ebx						;increase row counter as we printed a value
	cmp		ebx, 20					;evaluate if we need a new line	
	jz		NewLine
	jnz		FinishLoop
	
;Print a new line and reset the rowCounter
NewLine:
	call	CrLf
	sub		ebx, 20

;Go to the next loop
FinishLoop:
	add		edi, 4					;move to the next element
	loop	Display

	popad							;restore registers
	ret		16
displayList	ENDP

;Procedure to sort an array of integers in ascending order.
;receives: randArray, ARRAYSIZE
;returns: randArray sorted
;preconditions:  randArray exists
;registers changed: none
sortList	PROC
	pushad							;save registers
	mov		ebp, esp
	mov		edi, [ebp + 36]			;address of the randArray
	mov		ecx, [ebp + 40]			;value of size of the array

;below is insertion sort method for sorting
	dec		ecx
	mov		edx, 0					;count of elements in sorted area

SortLoop:	
	push	ecx						;save outer loop counter
	add		edi, 4					;move to next element in unsorted area
	push	edi						;save outer loop array position
	mov		eax, [edi]				;get value to check
	mov		esi, edi				;get starting address for second argument
	inc		edx						;update count of elements that are sorted
	mov		ecx, edx				;set for inner loop checking

InnerLoop:
	sub		esi, 4					;get position of argument in sorted area					
	mov		ebx, [esi]				;get second argument
	cmp		ebx, eax				;compare if we need to swap
	jl		NextLoop				;exit as sorted area is done
	push	edi						;push address of first value to swap
	push	esi						;push address of second value to swap
	call	exchangeElements		;call to exchange the elements in the array
	sub		edi, 4					;move to next position in sorted area for comparison
	loop	InnerLoop
	
NextLoop:
	pop		edi						;restore position in array
	pop		ecx						;restore count
	loop	SortLoop
	
	popad							;restore registers
	ret		8
sortList	ENDP

;Procedure to exchange elements
;receives: addresses of elements that need to be swapped in the array
;returns: none
;preconditions: elements exist  
;registers changed: none
exchangeElements	PROC
	pushad							;save registers
	mov		ebp, esp
	mov		esi, [ebp + 36]			;address of the second element
	mov		edi, [ebp + 40]			;address of the first element

	mov		eax, [edi]				;get first value
	mov		ebx, [esi]				;get second value

	mov		[esi], eax				;swap values
	mov		[edi], ebx				;swap values

	popad							;restore registers
	ret		8
exchangeElements	ENDP

;Procedure to calculate and display the median value.
;receives: randArray, ARRAYSIZE
;returns: none
;preconditions:  randArray must be sorted
;registers changed: none
displayMedian	PROC
	pushad							;save registers
	mov		ebp, esp
	mov		edi, [ebp + 36]			;address of the randArray
	mov		eax, [ebp + 40]			;value of size of the array
	mov		edx, 0					;clear the edx register
	mov		ebx, 2
	div		ebx						;divide the size of the array in half
	cmp		edx, 0					;compare the remainder to 0
	je		EvenMedian
	
;array has odd number of values
	mov		ebx, 4					;each array element is 4 bytes
	mul		ebx						;multiply by calculated position of median value
	add		edi, eax				;move to median value
	mov		eax, [edi]				;store median value to print
	jmp		ExitMedian	
	
EvenMedian:
	mov		ebx, 4					;each array element is 4 bytes 
	mul		ebx						;multiply by calculated mid-way point
	add		edi, eax				;move to the mid-way point
	mov		eax, [edi]				;store the value
	sub		edi, 4					;move to the second mid-way value
	add		eax, [edi]				;add this to our value
	mov		edx, 0					;clear the edx register
	mov		ebx, 2
	div		ebx						;divide our median value in half
	cmp		edx, 0					;check remainder
	jg		RoundUp					;remainder is 0.5
	jmp		ExitMedian				;don't need to round up

RoundUp:
	inc		eax						;round up
	
ExitMedian:	
	call	WriteDec	
	call	CrLf
	popad							;restore registers
	ret		8
displayMedian	ENDP

;Procedure to count the number of each value in the array.
;receives: randArray, ARRAYSIZE, countArray, LO
;returns: countArray filled with count of each value in the randArray
;preconditions:  randArray is sorted in ascending order
;registers changed: none
countList	PROC
	pushad							;save registers
	mov		ebp, esp
	mov		edi, [ebp + 36]			;address of the randArray
	mov		ecx, [ebp + 40]			;value of size of the randarray
	mov		esi, [ebp + 44]			;address of the countArray
	mov		eax, [ebp + 48]			;value of LO global constant
	mov		ebx, 0					;use as an accumulator

CountLoop:	
	mov		edx, [edi]				;element in array to check

CheckValue:
	cmp		eax, edx				;compare element
	je		AddValue				;equal to current count
	inc		eax						;increment to next count
	add		esi, 4					;move to the next position in the countArray
	mov		ebx, 0					;reset the accumulator
	mov		[esi], ebx				;save the 0 in case there are no instances
	jmp		CheckValue				;check again
	
AddValue:
	inc		ebx						;increment the accumulator
	mov		[esi], ebx				;save the value in the countArray
	add		edi, 4					;move to the next position in the randArray
	loop	CountLoop

	popad							;restore registers
	ret		16
countList	ENDP


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
