#include <stdio.h>
#include <stdlib.h>

/*
Napisati potprogram koji ispituje neoznačene 16-bitne vrednosti u nizu A.
Ukoliko član niza ima paran broj binarnih jedinica, zameniti sadržaje
njegova prva 3 i poslednja 3 bita. U suprotnom zameniti sadržaje njegovog
prvog i poslednjeg bita. Povratna vrednost potprograma je broj elemenata
niza koji imaju paran broj binarnih jedinica. Deklaracija potprograma je
data sa:
int RazmeniBit(unsigned short *A, unsigned N);
gde je A pokazivač na niz 16-bitnih vrednosti, a N broj elemenata niza.
*/

int RazmeniBit(unsigned short *A, unsigned N);

void printbin16(unsigned short int x) {
    unsigned short int m=0x8000, s=0;
    while(m) {
        printf("%s%s",m&x ? "1" : "0",++s%8 ? "" : " ");
        m >>= 1;
    }
}

int main()
{
    int br_par=0;
    int i;
    int n=5;
    unsigned short niz[5]={20, 7, 5, 65532, 17};

	printf("Niz pre poziva RazmeniBit():\n");
	for(i=0;i<n;i++){
		//printf(" %04x \n", niz[i]);
        printbin16(niz[i]);
        fprintf(stdout, "\n");
        
	}


    br_par=RazmeniBit(niz, n);


	printf("Niz posle poziva Razmeni Bit():\n");
	for(i=0;i<n;i++){
		//printf(" %04x \n", niz[i]);
        printbin16(niz[i]);
        fprintf(stdout, "\n");

	}
	printf("Broj el. sa parnim br. jedinica = %d\n\n", br_par);

    return 0;
}
