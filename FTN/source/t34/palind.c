#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX 16

int palindrom(char * str);

int main(){
	char *str;
	printf("Unesite palindrom:\n");
	fgets(str, MAX, stdin);
	int r;
	r = palindrom(str);
	printf("STRING:%s%s\n",str, r == 1 ? "PALINDROM" : "NIJE PALINDROM");

	return 0;
}
