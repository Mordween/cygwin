#include <stdio.h>
#include <unistd.h>

void main()
{
	for(int i=0; i<9; i++)
	{
		printf("i : %d \n", i);
		usleep(1*1000*1000);
	}

}