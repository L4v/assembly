.section .text
.global Izmesaj
Izmesaj:
    pushl %ebp
    movl %esp, %ebp
    movl 16(%ebp), %ecx
    xorl %eax, %eax
    movl 8(%ebp), %edx # a
prvih_n:
    andl %ecx, %ecx
    jz ostali_pre
    pushl %edx # Cuva edx na steku, jer ce se izbrisati dole
    shrl $1, %edx # Izbacuje bit edx-a u carry
    rcll $1, %eax # Rotira eax ubacujuci carry na najnizi bit
    popl %edx # Vraca vrednost sa steka na edx
    decl %ecx # Smanjuje brojac
    jmp prvih_n
ostali_pre:
    movl 12(%ebp), %edx # b
    movl $32, %ecx
    subl 16(%ebp), %ecx
ostali:
    andl %ecx, %ecx
    jz end
    pushl %edx # Cuva edx na steku, jer ce se izbrisati dole
    shrl $1, %edx # Izbacuje bit edx-a u carry
    rcll $1, %eax # Rotira eax ubacujuci carry na najnizi bit
    popl %edx # Vraca vrednost sa steka na edx
    decl %ecx # Smanjuje brojac
    jmp ostali
end:
    movl %ebp, %esp
    popl %ebp
    ret
