@ Lab1
@ Author: Patrick Berzins
@ prb0013@uah.edu
@ CS413-01 2022
@ Purpose: using arrays and autoindexing to perform arithmetic on values stored in arrays
@ Use these command to assemble, link and run this program
@    as -o berzinsLab1.o berzinsLab1.s
@    gcc -o berzinsLab1 berzinsLab1.o
@    ./berzinsLab1 ;echo $?
@    gdb --args ./berzinsLab1

.arch armv6
.fpu vfp
.equ READERROR, 0 @Used to check for scanf read error. 
.text
.global main

main:

@welcome user
Welcome:
   @ welcome user and provide instructions
   ldr r6, =A		@registers 6-8 point to arrays A B C respectively
   ldr r7, =B
   ldr r8, =C 
   mov r5, #0		@use r5 as loop counter
@ get user input 1-10
fillArrayB:
   		
   ldr r0, =welcomeMsg	@ load welcome prompt 
   bl  printf		@ print to screen 

   ldr r0, =intInputPattern	@load to read in one number
   ldr r1, =intInput		@load r1 with the adress of where input value will be stored
   			@load r1 tp r4 to avoid deletion by scanf
   bl  scanf
   cmp r0, #READERROR		@branch if readerror is found
   beq readerror
   ldr r1, =intInput        	@ Have to reload r1 because it gets wiped out.
   ldr r1, [r1]
   cmp r1, #0
   blt readerror		@ check if input is negative   
   
   str r1, [r7,r5,lsl#2]	@store value in array B
   add r5, r5, #1		@add 1 to index variable
   cmp r5, #10
   bne fillArrayB		@ keep looping till the array has been indexed through
   bl  multiply		@ branch to multiply loop
   ldr r0, =array1		@ load array name
   bl  printf		@ print to screen
   mov r4, r6		@ move array A into r4 
   bl  printArrays		@ branch to print loop
   
   ldr r0, =array2		@ load array name
   bl  printf		@ print to screen 
   mov r4, r7		@ move array B into r4 to print
   bl  printArrays 		@ branch to print loop

   ldr r0, =array3		@ load array name
   bl  printf		@ print to screen 
   mov r4, r8		@ move array C into r4 to print
   bl  printArrays		@ branch to print loop
   b   myExit		@exit

multiply:
   push {lr}		@save pc counter
   mov r5, #0		@ set index count to 0
loop:
   ldr r1, [r6, r5, lsl#2]	@load each variable of arrayA to r1
   ldr r2, [r7, r5, lsl#2] 	@ load each variable of arrayB to r2
   mul r0, r1, r2		@ multiply variable together
   str r0, [r8, r5, lsl#2]	@ store result into array C
   add r5, r5, #1		@increment counter
   cmp r5, #10		
   bne loop		@loop till array is full
   pop {pc}		@ give pc the counter back and go back to next code
   b   myExit		@ branch if fails

printArrays:		
   push {lr}		@ save pc count
   mov r5, #0		@ set counter to 0
printLoop:
   
   ldr r0, =strOutNum		@ load output
   ldr r1, [r4, r5, lsl#2]	@ load each variable of array
   bl  printf		@ print
   add r5, r5, #1		@ increment 1
   cmp r5, #10		
   bne printLoop		@ loop till array is printed 
   pop {pc}		@ give pc count back

readerror:

   ldr r0, =badInput		@ load error message
   bl printf

   ldr r0, =strInputPattern
   ldr r1, =strInputError  	@ Put address into r1 for read.
   bl scanf			@ scan keyboard
			@ clear input buffer
   b fillArrayB


@ exit code
myExit:

   mov r7, #0x01  		@ exit code
   svc 0         	 	@ exit


@ data for output prompts
.data
   .balign 4
   welcomeMsg: .asciz "Please enter a positive number to fill the array\n"
   .balign 4
   array1: .asciz "Array A: \n"
   .balign 4
   array2: .asciz "Array B: \n"
   .balign 4
   array3: .asciz "Array C: \n"
   .balign 4
   strInputPrompt: .asciz " "
   .balign 4
   strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 
   .balign 4
   badInput: .asciz "Invalid Input. Enter a positive number: \n"
   .balign 4
   intInputPattern: .asciz "%d"
   .balign 4
   intInput: .word 0   	@ Location used to store the user input. 
   .balign 4
   strInputError: .skip 100*4  	@ User to clear the input buffer for invalid input.
   .balign 4
   strOutNum: .asciz "%d \n" 
   .balign 4
   A: .word 1, 14, 13, 0, -19, 5, -9, 17, 0, 2 @initialized array A
   .balign 4
   B: .skip 10*4		@ int type array with 10 elements 
   .balign 4
   C: .skip 10*4		@ int type array with 10 elements 

.global printf
.global scanf
