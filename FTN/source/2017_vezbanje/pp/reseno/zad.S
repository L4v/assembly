# kalkulator 64-bitnih logičkih izraza u heksadecimalnom brojnom sistemu
# obe konverzije su rađene po niblovima (1 hex cifra = tačno 4 bita, odnosno 1 nibl)
# program, dodatno, preskače praznine na početku i kraju izraza
# i zahteva postojanje praznine između operanada i operatora

.section .data
hexconvert: .ascii "0123456789ABCDEF" #string za konverziju u hex broj
mess1:   .ascii "\nHeksadecimalni kalkulator logičkih operacija\n"
         .ascii "Unesite izraz (hex LOG hex): \0"
mess2:   .ascii "Rezultat: "
result:  .fill 12,1,0                 #rezultat se upisuje odmah iza poruke mess2
input_max = 50
input:   .fill input_max,1,0
error:   .byte 0                      #kôd greške
op:      .byte 0                      #operacija
errop1:  .ascii "Pogrešan prvi operand!\n\0"
errop2:  .ascii "Pogrešan drugi operand!\n\0"
errop1p: .ascii "Prekoračenje prvog operanda!\n\0"
errop2p: .ascii "Prekoračenje drugog operanda!\n\0"
errop:   .ascii "Pogrešna operacija!\n\0"

.section .text
.globl main

##########################################################
# makroi sa kôdom koji se koristi na više mesta u programu
# uvedeni su kako bi glavni program bio kraći (Dodatak D)
# za vežbu, umesto poziva makroa, implementirati odgovarajuće
# funkcije makroa kao potprograme, ili ubaciti kôd direktno
# u program na mestu poziva.

# preskakanje praznina u stringu na koga pokazuje registar
# makro menja indikatore i vrednost registra koji je prosleđen
.macro skip_space reg
1:  cmpb $' ',(\reg)
    jne 2f
    incl \reg
    jmp 1b
2:
.endm

# nalaženje prve praznine u stringu na koga pokazuje registar
# makro menja indikatore i vrednost registra koji je prosleđen
.macro find_space reg
1:  cmpb $' ',(\reg)
    je 2f
    incl \reg
    jmp 1b
2:
.endm

# ispis stringa na koga pokazuje registar
# (prethodno se računa dužina stringa na osnovu null terminatora)
# makro menja indikatore i registre eax, ebx, ecx i edx
.macro print_str string
    movl $4,%eax
    movl $1,%ebx
    movl $\string,%ecx
    movl $0,%edx
1:  cmpb $0,(%ecx)
    je 2f
    incl %ecx
    incl %edx
    jmp 1b
2:  movl $\string,%ecx
    int $0x80
.endm

##########################################################

# potprogram za konverziju iz stringa u hex osnovi u vrednost (direktno 4 po 4 bita)
# unsigned long long hex2llong(char* hex, unsigned char* err);
# err: 0 - OK, 1 - pogrešan znak, 2 - prekoračenje
hex2llong:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp       #lokalna promenljiva za grešku
    pushl %ebx
    pushl %esi
    movl $0,-4(%ebp)
    movl 8(%ebp),%ecx
    xorl %eax, %eax     #akumulacija rezultata, niži
    xorl %edx, %edx     #akumulacija rezultata, viši
h2l_petlja:
    movb (%ecx),%bl
    cmpb $' ',%bl       #provera kraja stringa (kraj je ili ' ' ili \0)
    je h2l_end
    cmpb $0,%bl
    je h2l_end
    testl $0xf0000000,%edx  #provera prekoračenja opsega
    jnz h2l_err2
    movl $4, %esi       #pomeranje, radi pravljenja mesta za novu hex cifru
h2l_shl:    
    shll $1, %eax
    rcll $1, %edx
    decl %esi
    jne h2l_shl
    cmpb $'0',%bl       #provera opsega 0-9
    jl h2l_err1
    cmpb $'9',%bl
    jg h2l_A
    subb $'0',%bl
    jmp h2l_ubaci
h2l_A:
    cmpb $'A',%bl       #provera opsega A-F
    jl h2l_err1
    cmpb $'F',%bl
    jg h2l_a
    subb $'A'-10,%bl
    jmp h2l_ubaci
h2l_a:
    cmpb $'a',%bl       #provera opsega a-f
    jl h2l_err1
    cmpb $'f',%bl
    jg h2l_err1
    subb $'a'-10,%bl
h2l_ubaci:
    orb %bl, %al        #ubacivanje vrednosti hex cifre u eax
    incl %ecx
    jmp h2l_petlja
h2l_err2:
    incl -4(%ebp)
h2l_err1:
    incl -4(%ebp)
h2l_end:
    movl 12(%ebp),%ecx
    movl -4(%ebp),%ebx
    movb %bl,(%ecx)
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret

# glavni program
main:
    # ispis početne poruke i unos stringa
    print_str mess1
    movl $3,%eax
    movl $0,%ebx
    movl $input,%ecx
    movl $input_max,%edx
    int $0x80
    movb $0,-1(%ecx,%eax,1) #upis ASCII 0 preko ASCII 10

    # obrada prvog operanda
    movl $input, %ebx
    skip_space %ebx     #preskakanje praznina na početku
    pushl $error        #prva konverzija
    pushl %ebx
    call hex2llong
    addl $8,%esp
    cmpb $1,error
    je err_op1
    cmpb $2,error
    je err_op1p
    pushl %eax          #čuvanje rezultata prve konverzije na steku
    pushl %edx

    # obrada operacije
    find_space %ebx     #preskakanje prvog operanda (ebx pokazuje na početak prvog operanda)
    skip_space %ebx     #traženje operacije
    movb (%ebx),%al
    movb %al, op

    # obrada drugog operanda
    incl %ebx           #druga konverzija
    skip_space %ebx
    pushl $error
    pushl %ebx
    call hex2llong
    addl $8,%esp
    cmpb $1,error
    je err_op2
    cmpb $2,error
    je err_op2p

    # izvršenje operacije
    popl %ecx           #skidanje rezultata prve konverzije sa steka
    popl %ebx
    cmpb $'&',op        #provera i izvršenje operacije
    jne op_xor
    andl %ebx, %eax
    andl %ecx, %edx
    jmp int2hex
op_xor:
    cmpb $'^',op
    jne op_or
    xorl %ebx, %eax
    xorl %ecx, %edx
    jmp int2hex
op_or:
    cmpb $'|',op
    jne err_op
    orl %ebx, %eax
    orl %ecx, %edx

# konverzija u hex string (direktno 4 po 4 bita)
int2hex:
    movb $15, %cl       #brojač cifara, može biti max 16 komada (0-15)
    movb $0, %ch        #indikacija cifre različite od 0 (izbegavanje vodećih nula)
    movl $result, %esi
hexdigit1:
    movl $4, %edi       #postavljanje cifre sa tekuće najviše pozicije na najnižu
hexdigit2:              #(odnosno, rotiranje ulevo za 4 pozicije)
    shll $1, %eax       
    rcll $1, %edx       
    rcrl $1, %eax
    roll $1, %eax
    decl %edi
    jne hexdigit2
    movl %eax, %edi
    andl $0xf, %edi     #izdvajanje najniže cifre, koristiće se kao indeks za hexconvert
    andb %ch, %ch       #da li je bilo cifara različitih od 0
    jnz hexdigit3
    andb %cl, %cl       #da li je poslednja cifra
    jz hexdigit3
    testb $0xf, %al     #da li je cifra različita od 0
    jz hexdigit4
hexdigit3:
    incb %ch
    movb hexconvert(,%edi,1), %bl
    movb %bl, (%esi)
    incl %esi
hexdigit4:
    decb %cl            #kad cl postane <0, obrađene su sve hex cifre
    jns hexdigit1

# ispis rezultata i završetak programa
    movb $10,(%esi)     #dodavanje newline-a na kraj ispisa
    movb $10,1(%esi)
    movb $0,2(%esi)
    print_str mess2
    movl $0, %ebx       #nema greške
end_program:
    movl $1, %eax
    int $0x80

# poruke o greškama
err_op1:
    print_str errop1
    movl $1, %ebx
    jmp end_program
err_op1p:
    print_str errop1p
    movl $2, %ebx
    jmp end_program
err_op2:
    print_str errop2
    movl $1, %ebx
    jmp end_program
err_op2p:
    print_str errop2p
    movl $2, %ebx
    jmp end_program
err_op:
    print_str errop
    movl $1, %ebx
    jmp end_program

