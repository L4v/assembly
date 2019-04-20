# NZD(a, b)
.section .text
.global main

main:
	movl $12, %eax
	movl $13, %ecx
	
compare:
	cmpl %eax, %ecx
	je end
	cmpl %eax, %ecx
	jg cvece
	cmpl %ecx, %eax
	jg avece
cvece:
	subl %eax, %ecx
	jmp compare
avece:
	subl %ecx, %eax
	jmp compare
end:
	movl $1, %eax
	int $0x80
