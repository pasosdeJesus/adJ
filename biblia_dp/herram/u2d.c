#include <stdio.h>

int main() {
	int c;
	c=getchar();
	while (c!=EOF && !feof(stdin)) {
		if (c=='\n') {
			putchar('\r');
		}
		putchar(c);
		c=getchar();
	}
	return 0;
}
