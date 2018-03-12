.equ SWI_Open, 0x66 @open a file
.equ SWI_Close,0x68 @close a file
.equ SWI_PrInt,0x6b @ Write an Integer
.equ SWI_RdInt,0x6c @ Read an Integer from a file
.equ Stdout, 1 @ Set output target to be Stdout
.equ SWI_Exit, 0x11 @ Stop execution
.text

@@----------- OPEN FILE FOR INPUT HERE ----------@@
ldr r0,=InFileName @ set Name for input file
mov r1,#0 @ mode is input
swi SWI_Open @ open file for input
ldr r1,=InputFileHandle @ if OK, load input file handle
str r0,[r1] @ save the file handle

@@----------- READ INPUT FROM FILE ----@@
ldr r0,=InputFileHandle @ load input file handle
ldr r0,[r0]
swi SWI_RdInt @ read the integer into R0

swi SWI_Close


@@------ INITIALIZING COUNTER VARIABLES COPYING INPUT INTEGER TO REGISTER -----@@
mov r2, r0
mov r8, #0  @ counter
mov r3, #5  @period counter

@@----------- OPEN FILE FOR OUTPUT HERE ----------@@
	    ldr r0,=OutFileName
            mov r1,#2
            swi SWI_Open 
	    ldr r1,=OutFileHandle
            str r0,[r1]

@@----------- LFSR CALCULATIONS-------------------@@

REGISTER:   mov r4, r2, lsr #0   
            mov r5, r2, lsr #2
            mov R6, r2, lsr #3
            mov R7, r2, lsr #5
            eor r4, r4, r5   
            eor r5, R6, R7
            eor r4, r4, r5
            and r4, r4, #1   
            mov r4, r4, lsl #15  
            mov r5, r2, lsr #1   
            orr r2, r4, r5    
            cmp r8, r3  @if loop 
            bge Exit
	    add r8, r8, #1 @ increment in counter variable  
@@---------- PRINT IN FILE -----@@            

            ldr r1,=OutFileHandle
            str r0,[r1]
            mov r1, r2
            swi SWI_PrInt
            b REGISTER
             

@@------ EXIT BRANCHING -------@@
Exit: 
        ldr r0, =OutFileHandle
        ldr r0, [r0]
        swi SWI_Close
        swi SWI_Exit @ stop executing   


@@------- DATA SEction -------@@
.data
InFileName: .asciz "in.txt"
InputFileHandle: .word 0
OutFileName: .asciz "out.txt"
OutFileHandle:.word 0                     
.end
