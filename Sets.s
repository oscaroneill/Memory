	AREA	Sets, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	
	LDR R0, =AElems			; R0 = elemAaddr
	LDR R10, [R0]			; R10 = elemA
	LDR R1, =BElems			; R1 = elemBaddr
	LDR R11, [R1]			; R11 = elemB
	LDR R2, =ASize
	LDR R2, [R2]			; R2 = lengthA
	LDR R3, =BSize
	LDR R3, [R3]			; R3 = lengthB
	LDR R4, =AElems			; R4 = origAaddr
	LDR R5, =BElems			; R5 = origBaddr
	LDR R6, =0				; R6 = countA
	LDR R7, =0				; R7 = countB
	LDR R8, =CElems			; R8 = setCaddr
	LDR R9, =CSize
	LDR R9, [R9]			; R9 = lengthC
	
aCheck						; Checking B elements against A elements
	CMP R6, R2				; if (countA == lengthA)
	BEQ aIsDone				;	aIsDone
	CMP R7, R3				; else if (countB == lengthB)
	BEQ bIsDone				;	bIsDone
	CMP R10, R11			; else if (elemA != elemB)
	BNE elemsNotEqual		;	elemsNotEqual
	CMP R10, R11			; else if (elemA == elemB)
	BEQ elemsAreEqual		; 	elemsAreEqual
	
aIsDone						; if (countA == lengthA)
	MOV R0, R4				; 	elemAaddr = origAaddr
	LDR R10, [R0]
	MOV R1, R5				; 	elemBaddr = origBaddr
	LDR R11, [R1]
	LDR R6, =0				; 	countA = 0
	LDR R7, =0				; 	countB = 0
	B bCheck				; 	Start checking the B elems
	
bIsDone						; if (countB == lengthB)
	STR R10, [R8]			; 	setC += elemA
	ADD R8, R8, #4			; 	Go to next C addr
	ADD R9, R9, #1			; 	lengthC += 1
	ADD R0, R0, #4			; 	Go to next A addr
	LDR R10, [R0]
	ADD R6, R6, #1			; 	countA += 1
	MOV R1, R5				; 	Baddr = origBaddr
	LDR R11, [R1]
	LDR R7, =0				; 	countB = 0
	B aCheck				; 	Check the next A elem
	
elemsNotEqual				; if (elemA != elemB)
	ADD R1, R1, #4			; 	Go to next B addr
	LDR R11, [R1]
	ADD R7, R7, #1			; 	countB += 1
	B aCheck				; 	Check the next B element
	
elemsAreEqual				; if (elemA == elemB)
	ADD R0, R0, #4			; 	Go to next A addr
	LDR R10, [R0]
	ADD R6, R6, #1			; 	countA += 1
	MOV R1, R5				; 	Baddr = origBaddr
	LDR R11, [R1]
	LDR R7, =0				; 	countB = 0
	B aCheck				; 	Check the next B element
	
bCheck						; Checking A elements against B elements
	CMP R7, R3				; if (countB == lengthB)
	BEQ endProgram			; 	endProgram
	CMP R6, R2				; else if (countA == lengthA)
	BEQ aIsDone2			;	aIsDone
	CMP R11, R10			; else if (elemB != elemA)
	BNE elemsNotEqual2		; 	elemsNotEqual
	CMP R11, R10			; else if (elemB == elemA)
	BEQ elemsAreEqual2		; 	elemsAreEqual
	
aIsDone2					; if (countA == lengthA)
	STR R11, [R8]			; 	setC += elemB
	ADD R8, R8, #4			; 	Go to next C addr
	ADD R9, R9, #1			; 	lengthC += 1
	ADD R1, R1, #4			; 	Go to next B elem
	LDR R11, [R1]
	ADD R7, R7, #1			; 	countB += 1
	MOV R0, R4				; 	Aaddr = origAaddr
	LDR R10, [R0]
	LDR R6, =0				; 	countA = 0
	B bCheck				; 	Check the next B elem
	
elemsNotEqual2				; if (elemB != elemA)
	ADD R0, R0, #4			; 	Go to next A addr
	LDR R10, [R0]
	ADD R6, R6, #1			; 	countA += 1
	B bCheck				; 	Check the next A elem
	
elemsAreEqual2				; if (elemB == elemA)
	ADD R1, R1, #4			; 	Go to next B elem
	LDR R11, [R1]
	ADD R7, R7, #1			; 	countB += 1
	MOV R0, R4				; 	Aaddr = origAaddr
	LDR R10, [R0]
	LDR R6, =0				; 	countA = 0
	B bCheck				; 	Check the next A elem

endProgram

stop	B	stop


	AREA	TestData, DATA, READWRITE
	
ASize	DCD	8					; Number of elements in A
AElems	DCD	12,5,14,16,17,8,24,2				; Elements of A

BSize	DCD	7					; Number of elements in B
BElems	DCD	17,2,14,12,5,8,24					; Elements of B

CSize	DCD	0					; Number of elements in C
CElems	SPACE	56				; Elements of C

	END	
