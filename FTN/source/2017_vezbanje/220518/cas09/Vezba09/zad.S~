# podaci drajvera ekrana
.section .data

# promenljive dostupne iz glavnog C programa
.extern scrwidth    # širina emuliranog ekrana
.extern scrheight   # visina emuliranog ekrana
.extern screen      # memorija emuliranog ekrana (scrwidth x scrheight)
.extern scrsize     # broj bajtova emuliranog ekrana (scrwidth*scrheight)

# interni podaci drajvera ekrana
cursorx:    .long 0 # x koordinata kursora
cursory:    .long 0 # y koordinata kursora
pbuff:      .fill 100,1,0   # bafer za generisanje ispisa na ekran

.section .text
.globl clearscr
.globl gotoxy
.globl printchr
.globl printstr
.globl printnum

#void clearscr();
clearscr:
    pushl %ebp
    movl %esp, %ebp
    xorl %eax, %eax
    movl scrsize, %eax
    clr:
    andl %eax, %eax
    jz end_clr
    movb $' ', screen-1(%eax)
    decl %eax
    jmp clr
    
    end_clr:
    popl %ebx
    popl %edi
    popl %esi
    movl %ebp, %esp
    popl %ebp
    ret

#int gotoxy(int x, int y);
gotoxy:
    ret

#void printchr(int chr);
printchr:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %ebx
	xorl %ebx, %ebx
	movl 8(%ebp), %ebx
	movl cursory, %eax
	mull scrwidth
	movl %eax, %esi
	addl cursorx, %esi
	prn_check:
		movb %bl, screen(%esi)
		incl cursorx
		movl scrwidth, %ecx
		movl cursorx, %edx
		cmpl %ecx, %edx
		je nLine
		jmp prnt_end
		nLine:
			movl scrheight, %ecx
			movl cursory, %edx
			cmpl %edx, %ecx
			je prnt_end
			incl cursory
			movl $0, cursorx
			jmp prnt_end
	
	prnt_end:
	popl %ebx
	popl %esi
	movl %ebp, %esp
	popl %ebp
    ret

#void printstr(char* str);
printstr:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
	movl 8(%ebp), %esi
	str_check:
		cmpb $0, (%esi)
		je prnt_str_end
		pushl (%esi)
		call printchr
		addl $4, %esp
		incl %esi
		jmp str_check


	prnt_str_end:
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
    ret

#void printnum(int num);
printnum:
    ret

