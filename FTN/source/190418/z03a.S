# int fibonaci(int n, int * rez) 0 nema greske / 1 greska prekoracenja
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
		jc greska
		jmp fib_calc

	greska:
		movl $1, %eax
		popl %esi
		movl %ebp, %esp
		popl %ebp
		ret
	
end:
	movl 12(%ebp), %edx
	movl %eax, (%edx)
	movl $0, %eax
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
