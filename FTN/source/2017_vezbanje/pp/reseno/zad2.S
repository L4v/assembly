# Program koji ulazni tekst modifikuje tako da iza svake njegove 3 reči
# ubacuje proizvoljan string (zadat u promenljivoj "string")

# Imenko Prezimić ra1234

.section .data
KORAK = 3
poruka1:    .ascii "Unesute neki tekst: \0"
poruka2:    .ascii "\n\nTekst sa ubacenim stringom:\n\0"
string:     .ascii "oOOo \0"
newline:    .ascii "\n\n\0"
korak:     .byte 0 # trenutni korak korekcije

INPUT_BUFF_LEN = 1024   #maksimalna dužina ulaznog teksta
input_buffer:    .fill INPUT_BUFF_LEN,1,0

.section .text
.globl main

# ispis stringa, dužina se računa u petlji
# void print_str(char *str)
print_str:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    movl $4, %eax
    movl $1, %ebx
    movl 8(%ebp), %ecx
    movl $0, %edx
print_find:
    cmpb $0, (%ecx, %edx,1)
    je print_end
    incl %edx
    jmp print_find
print_end:
    int $0x80
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret

# glavni program
main:
    # preuzimanje znakova sa ulaza
    pushl $poruka1
    call print_str
    addl $4, %esp
    movl $3, %eax
    movl $0, %ebx
    movl $input_buffer, %ecx
    movl $INPUT_BUFF_LEN, %edx
    int $0x80
    movb $0, -1(%ecx,%eax,1)

    movb $KORAK+1, korak # početni korak
    movl %ecx, %esi # adresa ulaznog stringa

    pushl $poruka2
    call print_str
    addl $4, %esp

main_kor:
    decb korak             # da li treba ubaciti string
    jnz main_rec0
    movb $KORAK, korak
    pushl $string
    call print_str
    addl $4, %esp

main_rec0:
    movl %esi, %edi
    # traženje kraja tekuće reči
main_rec:
    cmpb $0, (%esi)
    je main_rec_ispis
    cmpb $'A', (%esi)
    jl main_rec_kraj2
    cmpb $'Z', (%esi)
    jle main_rec_kraj
    cmpb $'a', (%esi)
    jl main_rec_kraj2
    cmpb $'z', (%esi)
    jg main_rec_kraj2
main_rec_kraj:
    incl %esi
    jmp main_rec
    # traženje početka sledeće reči
main_rec_kraj2:
    cmpb $0, (%esi)
    je main_rec_ispis
    cmpb $'.', (%esi)
    je main_rec_kraj3
    cmpb $'?', (%esi)
    je main_rec_kraj3
    cmpb $'!', (%esi)
    je main_rec_kraj3
    cmpb $'A', (%esi)
    jl main_rec_kraj3
    cmpb $'Z', (%esi)
    jle main_rec_ispis
    cmpb $'a', (%esi)
    jl main_rec_kraj3
    cmpb $'z', (%esi)
    jle main_rec_ispis
main_rec_kraj3:
    incl %esi
    jmp main_rec_kraj2

main_rec_ispis:
    movb (%esi), %al    # čuvanje znaka iza reči
    pushl %eax
    movb $0, (%esi)     # privremeno stavljanje NULL terminatora
    pushl %edi          # ispis reči
    call print_str
    addl $4, %esp
    popl %eax
    movb %al, (%esi)    # vraćanje sačuvanog znaka
    cmpb $0, (%esi)
    jne main_kor

    pushl $newline
    call print_str
    addl $4, %esp

    movl $1, %eax       # kraj programa
    movl $0, %ebx
    int $0x80

