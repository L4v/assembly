#include <stdio.h>
#include <stdlib.h>
// LICNA IZMENA ZA PRINTOVANJE BINARNIH BROJEVA
#define BYTE_TO_BINARY_PATTERN "%c%c%c%c%c%c%c%c"
#define BYTE_TO_BINARY(byte)  \
  (byte & 0x80 ? '1' : '0'), \
  (byte & 0x40 ? '1' : '0'), \
  (byte & 0x20 ? '1' : '0'), \
  (byte & 0x10 ? '1' : '0'), \
  (byte & 0x08 ? '1' : '0'), \
  (byte & 0x04 ? '1' : '0'), \
  (byte & 0x02 ? '1' : '0'), \
  (byte & 0x01 ? '1' : '0') 

int RazmeniBit(unsigned short *A, unsigned N);

int main()
{
    int br_par=0;
    int i;
    int n=5;
    unsigned short niz[5]={20, 7, 5, 65532, 17};

	printf("Niz pre poziva RazmeniBit():\n");
	for(i=0;i<n;i++){
		//printf(" %04x \n", niz[i]);
		// LICNA IZMENA ZA PRINTOVANJE BINARNIH BROJEVA
		printf("m: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
  BYTE_TO_BINARY(niz[i]>>8), BYTE_TO_BINARY(niz[i]));

	}

    br_par=RazmeniBit(niz, n);


	printf("Niz posle poziva Razmeni Bit():\n");
	for(i=0;i<n;i++){
		//printf(" %04x \n", niz[i]);
		// LICNA IZMENA ZA PRINTOVANJE BINARNIH BROJEVA
		printf("m: "BYTE_TO_BINARY_PATTERN" "BYTE_TO_BINARY_PATTERN"\n",
  BYTE_TO_BINARY(niz[i]>>8), BYTE_TO_BINARY(niz[i]));

	}
	printf("Broj el. sa parnim br. jedinica = %d\n\n", br_par);

    return 0;
}

