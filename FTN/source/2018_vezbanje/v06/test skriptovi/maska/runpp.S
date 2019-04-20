# pomoćni potprogram za pokretanje studentskih potprograma
# proverava da li su sačuvani svi registri koji treba da se sačuvaju

.section .data
#promenljive za čuvanje sadržaja registara
RUNPP_REG_EBX: .long 0
RUNPP_REG_ESI: .long 0
RUNPP_REG_EDI: .long 0
RUNPP_REG_EBP: .long 0
RUNPP_REG_RET: .long 0
#vrednost za proveru čuvanja
REGVAL = 0xA5F2E9C7

#indikacija nesačuvanih registara
.extern RUNPP_REG_ERR

.section .text
.globl runpp
runpp:
    #sačuvaj registre
    movl %ebx, RUNPP_REG_EBX
    movl %esi, RUNPP_REG_ESI
    movl %edi, RUNPP_REG_EDI
    movl %ebp, RUNPP_REG_EBP
    movl $REGVAL, %ebx
    movl $REGVAL+42, %esi
    movl $REGVAL+13, %edi
    movl $REGVAL+27, %ebp

    #skini povratnu adresu i sačuvaj
    popl %ecx
    movl %ecx, RUNPP_REG_RET

    #poziv potprograma
    call zadatak

    #proveri da li su registri ispravno sačuvani
    cmpl $REGVAL, %ebx
    je 1f
    orl $0x01,RUNPP_REG_ERR
1:  cmpl $REGVAL+42, %esi
    je 1f
    orl $0x02,RUNPP_REG_ERR
1:  cmpl $REGVAL+13, %edi
    je 1f
    orl $0x04,RUNPP_REG_ERR
1:  cmpl $REGVAL+27, %ebp
    je 1f
    orl $0x08,RUNPP_REG_ERR

    #vrati sadržaje registara
1:  movl RUNPP_REG_EBX, %ebx
    movl RUNPP_REG_ESI, %esi
    movl RUNPP_REG_EDI, %edi
    movl RUNPP_REG_EBP, %ebp
    movl RUNPP_REG_RET, %ecx
    pushl %ecx
    ret

