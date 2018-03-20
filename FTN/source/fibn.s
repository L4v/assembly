#FIBONACCI-N 1 1 2 3 5 8 13 21 34 55...
.section .text
.global main

main:
	movl $1, %eax	#x1 = 1
	movl $1, %ebx	#x2 = 1
	movl $10, %ecx	#i = 10	
fib:
	cmpl $0, %ecx
	je end
	
	movl %eax, %edx	#temp = x1
	addl %ebx, %edx	#temp += x2
	
	movl %ebx, %eax	#x1 = x2
	movl %edx, %ebx	#x2 = temp
	subl $1, %ecx	#i --
	jmp	fib
end:
	movl $1, %eax
	int $0x80
