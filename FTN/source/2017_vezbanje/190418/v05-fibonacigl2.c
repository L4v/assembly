#include <stdio.h>

//povratna vrednost je greska (0- nema, 1 - prekoracenje)
int fibonaci(int n, int* rez);

int main()
{
    int f, n=150, g;
    g = fibonaci(n, &f);
    if (g)
        printf("Greška!\n");
    else
        printf("fibonaci(%d)=%d\n", n, f);
}
