#
# Ucitava podatke o ocenama i prikazuje ih procentualno i graficki
# Prijavljuje eventualne greske pri unosu
#

.section .data
unostxt1: .ascii "Unesi broj ocena "
uocena: .ascii "%d : "
unoslen1=.-unostxt1

br_ocena=5
broc_niz: .fill br_ocena,4,0
broc_len=20
broc_txt: .fill broc_len,1,0
greska_txt: .ascii "Greska!\n"
greska_len=.-greska_txt

# stringovi se u memoriji nastavljaju jedan na drugi i ispisuju se zajedno
izlaz_str: .ascii "Procenat ocena  "
iocena:	.ascii "%d je: "
iprocenat: .ascii "%d% "
stub_str:	.fill 10,1,' '
	.byte '\n'
izlaz_str_len=.-izlaz_str


broc_suma: .long 0

.section .text
.globl main

# ispis_str - ispis stringa (makro, dodatak D)
# parametri: adr.stringa, br.znakova
# koristi: eax,ebx,ecx,edx
.macro ispis_str adrstr, brznak
	movl $4,%eax
	movl $1, %ebx
	movl \adrstr, %ecx
	movl \brznak, %edx
	int $0x80
.endm

# unos_str - unos stringa (makro, dodatak D)
# parametri: adr.bafera, br.znakova
# koristi: eax,ebx,ecx,edx
.macro unos_str adrstr, brznak
	movl $3,%eax
	movl $1, %ebx
	movl \adrstr, %ecx
	movl \brznak, %edx
	int $0x80
.endm

main:

# Petlja ulaza:
# - ispis poruke za unos
# - unos broja
# - konverzija u int
# - smestanje u niz broc_niz
	xor %esi, %esi
upetlja:
	cmpl $br_ocena, %esi
	je dalje1
	movl $6, %eax
	addl %esi, %eax
	pushl $uocena
	pushl %eax
	call iuz2cif
	addl $8, %esp

	ispis_str $unostxt1, $unoslen1

	unos_str $broc_txt, $broc_len

	pushl %ecx
	call zui
	addl $4, %esp
	andl %edx, %edx
	jnz greska_kraj

	movl %eax, broc_niz(,%esi,4)
	addl %eax, broc_suma	

	incl %esi
	jmp upetlja

dalje1:	
# Izlazna petlja:
# - formiranje izlaznog stringa za elemente niza broc_niz
# 	- nalazenje procenta
#	- konverzija i ubacivanje u izl. str.
#	- formiranje stuba za grafikon
	xor %esi, %esi
ipetlja:
# konverzija indeksa u ocenu
	cmpl $br_ocena, %esi
	je dalje2
	movl $6, %eax
	addl %esi, %eax
	pushl $iocena
	pushl %eax
	call iuz2cif
	addl $8, %esp
# racunanje i konverzija procenta
	movl broc_niz(,%esi,4), %eax
	movl $100, %ebx
	mull %ebx   #procenat moze biti max 100, => edx = 0 posle ove naredbe
	movl broc_suma, %ebx
	andl %ebx, %ebx
	jz greska_kraj
	divl %ebx   #edx se ne mora postavljati na 0
	pushl %eax
	pushl $iprocenat
	pushl %eax
	call iuz2cif
	addl $8, %esp
	xorl %ecx,%ecx
# formiranje stuba za grafikon
	popl %eax
	movb $10, %cl
	divb %cl
	movl $stub_str, %edx
stub_petlja:
	decb %al
	js stub_razmak
	movb $'#', (%edx)
	jmp stub_dalje
stub_razmak:
	movb $' ', (%edx)
stub_dalje:
	incl %edx
	decb %cl
	jz dalje11
	jmp stub_petlja

dalje11:
	ispis_str $izlaz_str, $izlaz_str_len
	incl %esi
	jmp ipetlja

dalje2:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80

# iuz2cif - kovertuje int u str. od 2 cifre (0-100)
# parametri: 8ebp=broj, 12ebp=adr.str.
iuz2cif:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp),%eax
	movl 12(%ebp),%ecx
	movb $10, %dl
	divb %dl
	addw $0x3030, %ax   #inicijalno su cifre '00'
	cmpb $'0', %al
	jnz dalje1_iuz2cif
	movb $' ', %al
dalje1_iuz2cif:
	cmpb $':', %al
	jnz dalje2_iuz2cif
	movb $'1', -1(%ecx)
	movb $'0', %al
	jmp kraj_iuz2cif
dalje2_iuz2cif:
	movb $' ', -1(%ecx)
kraj_iuz2cif:
	movw %ax, (%ecx)
	movl %ebp, %esp
	popl %ebp
	ret

# zui - konvertuje str. u int
#
# parametri: 8ebp=adr.str.
# izlaz: eax=konv.vrednost, edx-greska
zui:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %edi
	movl 8(%ebp), %ecx
	xorl %eax, %eax
	movl $10, %ebx
zui_petlja:	
	movb (%ecx), %dl
	cmpb %bl, %dl
	je kraj_zui
	subb $'0', %dl
	js zui_greska
	cmpb $9, %dl
	ja zui_greska
	movl %edx, %edi
	mull %ebx
	jc zui_greska
	addl %edi, %eax
	jc zui_greska
	incl %ecx
	jmp zui_petlja
zui_greska:
	movl $1, %edx
	jmp kraj_zui2
kraj_zui:
	movl $0, %edx
kraj_zui2:
	popl %edi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret

# greska_kraj - zavrsetak u slucaju greske
greska_kraj:
	ispis_str $greska_txt, $greska_len

	movl $1, %eax
	movl $-1, %ebx
	int $0x80

