	AREA	Lotto, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR	R0, =TICKETS			; R0 = ticketAddr
	LDRB R1, [R0]				; R1 = ticketElem
	LDR R2, =DRAW				; R2 = drawAddr
	LDR R3, =DRAW				; R3 = drawOrigAddr
	LDRB R4, [R2]				; R4 = drawElem
	LDR R5, =0				; R5 = numOfEqual
	LDR R6, =0				; R6 = ticketCount
	LDR R7, =0				; R7 = drawCount
	LDR R8, =MATCH4				; R8 = match4Addr
	LDR R9, =MATCH5				; R9 = match5Addr
	LDR R10, =MATCH6			; R10 = match6Addr
	LDR R11, =0				; R11 = numOfTickets
	LDR R12, =COUNT
	LDR R12, [R12]				; R12 = totalNumOfTickets
	
checkLoop
	CMP R7, #6				; if (drawCount == 6)
	BEQ drawCount6				;	drawCount6
	CMP R6, #6				; else if (ticketCount == 6)
	BEQ ticketCount6			;	ticketCount6
	CMP R1, R4				; else if (ticketElem == drawElem)
	BEQ elemsEqual				;	elemsEqual
	CMP R1, R4				; else if (ticketElem != drawElem)
	BNE elemsUnequal			;	elemsUnequal
	
drawCount6					; if (drawCount == 6) 
	ADD R0, R0, #1				; 	
	LDRB R1, [R0]				;	Go to next ticket elem
	MOV R2, R3				; 
	LDRB R4, [R2]				;	Go to first draw elem
	LDR R7, =0				;	drawCount = 0
	ADD R6, R6, #1				;	ticketCount++
	B checkLoop				; 	Check
	
ticketCount6					; if (ticketCount == 6)
	CMP R5, #4				; 	if (numOfEqual == 4)
	BEQ addToMatch4				;		Add to MATCH4 result
	CMP R5, #5				;	else if (numOfEqual == 5)
	BEQ addToMatch5				;		Add to MATCH5 result
	CMP R5, #6				;	else if (numOfEqual == 6)
	BEQ addToMatch6				;		Add to MATCH6 result
	B ticketCount6Part2			; 	else there's no result to add
	
addToMatch4					; if (numOfEqual == 4)
	LDR R3, =1				;	temp = 1
	STR R3, [R8]				;	Add 1 to MATCH4
	LDR R3, =DRAW				;	Re-use R3 for drawOrigAddr
	B ticketCount6Part2			; 	Continue

addToMatch5					; if (numOfEqual == 5)
	LDR R3, =1				;	temp = 1
	STR R3, [R9]				; 	Store numOfEqual in MATCH5
	LDR R3, =DRAW				;	Re-use R3 for drawOrigAddr
	B ticketCount6Part2			;	Continue
	
addToMatch6					; if (numOfEqual == 6)
	LDR R3, [R10]				;	temp = Current numOfEquals in memory
	ADD R3, R3, #1				;	Add to that num
	STR R3, [R10]				;	Store numOfEqual in MATCH6
	LDR R3, =DRAW				;	Re-use R3 for drawOrigAddr
	B ticketCount6Part2			; 	Coninue
	
ticketCount6Part2
	ADD R11, R11, #1			; numOfTickets++;
	CMP R11, R12				; if (numOfTickets == totalNumOfTickets) 
	BEQ stop				;	End program
	LDR R6, =0				; ticketCount = 0
	LDR R5, =0				; numOfEqual = 0;
	B checkLoop				; Check next elements
								
elemsEqual					; if (ticketElem == drawElem)
	ADD R5, R5, #1				; 	numOfEqual++
	ADD R0, R0, #1					
	LDRB R1, [R0]				;	Go to next ticket elem
	MOV R2, R3					
	LDRB R4, [R2]				;	Go to first draw elem
	LDR R7, =0				;	drawCount = 0
	ADD R6, R6, #1				;	ticketCount++
	B checkLoop				;	Check
	
elemsUnequal					; if (ticketElem != drawElem)
	ADD R2, R2, #1				;	
	LDRB R4, [R2]				; 	Go to next draw elem
	ADD R7, R7, #1				;	drawCount++
	B checkLoop				;	Check

stop	B	stop 



	AREA	TestData, DATA, READWRITE
	
COUNT	DCD	3				; Number of Tickets
TICKETS	DCB	23, 24, 28, 26, 16, 5		; Tickets
	DCB	10, 11, 33, 45, 29, 65
	DCB	28, 27, 26, 25, 24, 23
	

DRAW	DCB	23, 24, 25, 26, 27, 28		; Lottery Draw

MATCH4	DCD	0
MATCH5	DCD	0
MATCH6	DCD	0

	END	
