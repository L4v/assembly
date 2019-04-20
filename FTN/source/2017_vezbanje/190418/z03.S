# int fibonaci(int n) 1 1 2 3 5 8
.section .data
fib_max:	.long 0
.section .text
.global fibonaci
fibonaci:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	movl 8(%ebp), %edx
	movl %edx, fib_max
	movl $0, %ecx
	movl $1, %eax
	movl $1, %edx
	
	fib_calc:
		incl %ecx
		cmpl fib_max, %ecx
		je end
		cmpl $2, %ecx
		jl fib_calc
		movl %edx, %esi
		movl %eax, %edx
		addl %esi, %eax
		jmp fib_calc

	
end:
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
