.section .text
.global RazmeniBit
RazmeniBit:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp # Rezervacija za lokalnu promenljivu
    pushl %esi

    movl 8(%ebp), %esi # Adresa broja
    movl 12(%ebp), %ecx
    movl %ecx, -4(%ebp) # Duzina niza
    movl $0, -8(%ebp) # Za brojanje parnih

brojanje_bita_pre: # Postavlja preduslove potrebne za proveru
    cmpl $0, -4(%ebp)
    je end
    movl $1, %edx # Postavlja masku u ceo edx, cisti visi deo registra
    xorl %ecx, %ecx # Anulira ceo ecx, sluzi za brojanje

brojanje_bita:
    testw (%esi), %dx
    jz preskoci
    incl %ecx
preskoci:
    shlw $1, %dx
    jc proveri_parnost
    jmp brojanje_bita

proveri_parnost:
    shrl $1, %ecx
    jc neparno
    incl -8(%ebp) # Povecava broj parnih

    movw $0xe000, %dx # Maska_1 za visa tri bita 1110000...
    andw (%esi), %dx # Uzima prvi "otisak" visa tri bita
    rolw $3, %dx # rotira prvi "otisak"

    movw $0x0007, %ax # Maska_2 za niza tri bita ..0000111
    andw (%esi), %ax # Uzima drugi "otisak" niza tri bita
    rorw $3, %ax # rotira drugi "otisak"
    orw %ax, %dx # spaja oba "otiska" i smesta u dx

    movw $0x1ff8, %ax # Maska_3 za sredinu broja 0001...1111...1000
    andw (%esi), %ax # Uzima treci "otisak" sredine
    orw %ax, %dx # spaja sve u jedan "otisak" i smesta u dx

    movw %dx, (%esi) # Ubacuje gotov broj u niz
    jmp kraj_iteracije

neparno:
    movw $0x8000, %dx # Maska_1 za visi bit 10000...
    andw (%esi), %dx # Uzima prvi "otisak" viseg bita
    rolw $3, %dx # rotira prvi "otisak"

    movw $0x0001, %ax # Maska_2 za nizi bit ..00001
    andw (%esi), %ax # Uzima drugi "otisak" nizeg bita
    rorw $3, %ax # rotira drugi "otisak"
    orw %ax, %dx # spaja oba "otiska" i smesta u dx

    movw $0x7ffe, %ax # Maska_3 za sredinu broja 01...1111...10
    andw (%esi), %ax # Uzima treci "otisak" sredine
    orw %ax, %dx # spaja sve u jedan "otisak" i smesta u dx

    movw %dx, (%esi) # Ubacuje gotov broj u niz
kraj_iteracije:
    addl $2, %esi # Pomera pokazivac za 2 byte-a
    decl -4(%ebp)
    jmp brojanje_bita_pre

end:
    movl -8(%ebp), %eax
    popl %esi
    movl %ebp, %esp
    popl %ebp
    ret
