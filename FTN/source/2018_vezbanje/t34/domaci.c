#include <stdlib.h>
#include <stdio.h>

/*
    Napisati potprogram koji kao argumente prima 3 vrednosti
    a, b i n (0 <= n <= 32), a kao povratnu vrednost vraca
    koliko vrednosti najnizih n-bit-a odgovaraju vrednosti a, a
    preostali biti odgovaraju vrednosti b
    Pretpostavlja se da su uneti brojevi korektni, tj.
    a = {0, 1}, b = {0, 1}, n = [0, 32]
*/

void printbin32(unsigned int x) {
    unsigned int m=0x80000000, s=0;
    while(m) {
        printf("%s%s",m&x ? "1" : "0",++s%16 ? "" : " ");
        m >>= 1;
    }
}

int Izmesaj(int a, int b, int n);

int main(void){
    int a = 0, b = 0, n = 0;

    while(1){
        fprintf(stdout, "Uneti a, b, n ili ctrl-c za prekid\n");
        scanf("%d%d%d", &a, &b, &n);
        fprintf(stdout, "a = %d, b = %d, n = %d => ", a, b, n);
        printbin32(Izmesaj(a, b, n));
        fprintf(stdout, "\n");
    }

    return 0;
}
