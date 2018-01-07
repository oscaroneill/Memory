	AREA	Countdown, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	
	LDR	R1, =cdWord			; R1 = wordAddr
	LDR	R2, =cdLetters			; R2 = letterAddr
	LDRB R3, [R1]				; R3 = wordElem
	LDRB R4, [R2]				; R4 = letterElem
	LDR R5, =cdLetters			; R5 = origLetterAddr
	LDR R6, =0x00000024			; R6 = '$'
	
whLoop
	CMP R3, #0				; if (wordElem == NULL)
	BEQ wordIsNull				;	wordIsNull
	CMP R4, #0				; if (letterElem == NULL)
	BEQ letterIsNull			; 	letterIsNull
	CMP R3, R4				; if (wordElem != letterElem)
	BNE elemsNotEqual			;	elemsNotEqual
	CMP R3, R4				; if (wordElem == letterElem)
	BEQ elemsAreEqual			;	elemsAreEqual
	
wordIsNull					; if (wordElem == NULL)
	LDR R0, =1				;	Result = true
	B stop					;	End program
	
letterIsNull					; if (letterElem == NULL)
	LDR R0, =0				;	Result = false
	B stop					; 	End program
	
elemsNotEqual					; if (wordElem != letterElem)
	ADD R2, R2, #1				;	Go to next letter address
	LDRB R4, [R2]				;	Load letter
	B whLoop				;	Repeat
	
elemsAreEqual					; if (wordElem == letterElem)
	STRB R6, [R2]				;	Replace letter with $
	ADD R1, R1, #1				;	Go to next word address
	LDRB R3, [R1]				;	Load word
	MOV R2, R5				;	Go to beginning of letters
	LDRB R4, [R2]				;	Load letter
	B whLoop				;	Repeat

stop	B	stop



	AREA	TestData, DATA, READWRITE
	
cdWord
	DCB	"beets",0

cdLetters
	DCB	"daetebzsb",0
	
	END	
