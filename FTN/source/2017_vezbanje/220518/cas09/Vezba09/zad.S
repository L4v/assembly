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
.globl scroll_down

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
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	movl 8(%ebp), %esi
	movl 12(%ebp), %edi
	
	coord_check:
		cmpl scrwidth, %esi
		jae err
		cmpl scrheight, %edi
		jae err
		movl %esi, cursorx
		movl %edi, cursory
		xorl %eax, %eax
		jmp gotoxy_end
	
	err:
		movl $1, %eax
	
gotoxy_end:
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
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
		cmpb $'\t', %bl
		jne not_tab
		
		movl cursorx, %eax
		xorl %edx, %edx
		movl $10, %edi
		divl %edi
		andl %edx, %edx
		jz remain_0
		subl %edx, %edi
		pushl %edi
		call movCursor
		addl $4, %esp
		jmp write
		
	remain_0:
		movl $10, %edi
		pushl %edi
		call movCursor
		addl $4, %esp
		jmp prnt_end
		
	not_tab:
		cmpb $'\n', %bl
		jne not_new
		
		movl cursory, %eax
		incl %eax
		cmpl scrheight, %eax
		je new_scroll #
		incl cursory
		movl $0, cursorx
		jmp prnt_end
		
	new_scroll:
		call scroll_down
		jmp prnt_end
	
	not_new:
		cmpb $'\r', %bl
		jne write
		movl $0, cursorx
		jmp prnt_end
	
	
	
	###
		write:
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
			incl %edx
			cmpl %edx, %ecx
			je nLine_scroll # err
				incl cursory
				movl $0, cursorx
				jmp prnt_end
			nLine_scroll:
				call scroll_down
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
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	movl 8(%ebp), %eax
	leal pbuff, %esi
	xorl %edi, %edi
	cmpl $0, %eax
	jg convert
	negl %eax
	incl %edi
	convert:
		andl %eax, %eax
		jz pre_flip
		xorl %edx, %edx
		movl $10, %ecx
		divl %ecx
		addb $'0', %dl
		movb %dl, (%esi)
		incl %esi
		jmp convert
	
		
	pre_flip:
		andl %edi, %edi
		jz positive
		movb $'-', (%esi)
		incl %esi
	positive:	
		movb $0, (%esi)
		decl %esi
		movl %esi, %eax
		leal pbuff, %esi
		xorl %edx, %edx
		xorl %ecx, %ecx
		jmp flip
		
	flip:
		cmpl %eax, %esi
		jae printnum_end
		movb (%eax), %cl
		movb (%esi), %dl
		movb %dl, (%eax)
		movb %cl, (%esi)
		decl %eax
		incl %esi
		jmp flip

printnum_end:
	leal pbuff, %esi
	pushl %esi
	call printstr
	addl $4, %esp
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp	
    ret
###############################   
#CUSTOM CALLS
#movCursor (int ammount)
movCursor:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	mov:
		cmpl $0, %eax
		je movCursor_end
		movl cursorx, %ecx
		cmpl scrwidth, %eax
		je go_down
		incl cursorx
		decl %eax
		jmp mov
		
		go_down:
				movl cursory, %edx
				incl %edx
				cmpl scrheight, %edx
				je cursor_scroll # err
				incl cursory
				movl $0, cursorx
				decl %eax
				jmp mov
				cursor_scroll:
					call scroll_down
					decl %eax
					jmp mov
	
	
movCursor_end:
	movl %ebp, %esp
	popl %ebp
	ret

scroll_down:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	movl $0, cursorx
	movl $1, cursory
	xorl %edi, %edi
	movl scrwidth, %esi
	xorl %ecx, %ecx
	
	scroll_main:
		movl cursorx, %edx
		andl %ecx, %ecx
		jnz last_pass
		cmpl scrwidth, %edx
		je reset_x
	last_pass:
		cmpl scrwidth, %edx
		je scr_down_end
		xorl %edx, %edx
		movl cursory, %eax
		mull scrwidth
		movl %eax, %esi
		addl cursorx, %esi
		movl cursory, %eax
		decl %eax
		mull scrwidth
		movl %eax, %edi
		addl cursorx, %edi
		movb screen(%esi), %dl
		movb %dl, screen(%edi)
		movl cursory, %eax
		incl %eax
		andl %ecx, %ecx
		jz not_bottom
		movb $' ', screen(%esi)
	not_bottom:
		incl cursorx
		jmp scroll_main
		
	reset_x:
		movl $0, cursorx
		movl cursory, %eax
		incl %eax
		cmpl scrheight, %eax
		je set_flag
		incl cursory
		jmp scroll_main
	set_flag:
		incl %ecx
		jmp scroll_main
				
	
scr_down_end:
	movl $0, cursorx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret

