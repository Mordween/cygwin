#include "plasma.h"

#define MemoryRead(A) (*(volatile unsigned int*)(A))
#define MemoryWrite(A,V) *(volatile unsigned int*)(A)=(V)

int putchar(int value);
int puts(const char *string);

void wait_it(int value);
void Led(int value);
int SW(void);
int BTN_R(void);
int BTN_L(void);
int BTN_U(void);
int BTN_D(void);
void chenillard(void);
void VGA_COLOR(int value);

int main()
{
	puts("demarrage : \r\n");
	chenillard();
	
	puts("fin chenillard \r\n");
	
	while(1)
	{
		if(BTN_R() == 1)
		{
			puts("R \r \n");
			Led(10);
			//VGA_COLOR(256);
		}
		if(BTN_L() == 1)
		{
			puts("L \r \n");
			//VGA_COLOR(4096);
			Led(50);
		}
		if(BTN_U() == 1)
		{
			puts("U \r \n");
			//VGA_COLOR(2023);
			Led(100);
		}
		if(BTN_D() == 1)
		{
			puts("D \r \n");
			//VGA_COLOR(0);
			Led(150);
		}
		
	}
	
	return 0;
}



/*
 * Fonctions of test_led.c 
 *
 */

void wait_it(int value)
{
	int i =0;
	for( i=0; i < (value*6250); i++)  // 25000 *500 ~= 2 sec (à check) 
	{
		//do nothing
	}
}


void Led(int value)
{
	 MemoryWrite(GPIO1_CLEAR, (~value) & 0xff); //clear
	 MemoryWrite(GPIO1_OUT, value); //Change LEDs
}

// gpioA_in(7 downto 0) => switch(7 downto 0)
int SW(void)
{
	int valeur =  (MemoryRead(GPIOA_IN) & 0x00ff);
	return valeur;
}

// gpioA_in(11) => btnR
// gpioA_in(10) => btnL
// gpioA_in(9) => btnU
// gpioA_in(8) => btnD
int BTN_R(void)
{
	if( (MemoryRead(GPIOA_IN) & 0x0800) == 0x0800)
	{
		return 1;
	}
	return 0;
}

int BTN_L(void)
{
	if((MemoryRead(GPIOA_IN) & 0x0400) == 0x0400)
	{
		return 1;
	}
	return 0;
}

int BTN_U(void)
{
	if((MemoryRead(GPIOA_IN) & 0x0200) ==  0x0200)
	{
		return 1;
	}
	return 0;
}

int BTN_D(void)
{
	if((MemoryRead(GPIOA_IN) & 0x0100) == 0x0100)
	{
		return 1;
	}
	return 0;
}

void chenillard(void)
{
	int i =0;
	int final = SW();
	for(i =0; i<final; i++)
	{
		Led(i);
		wait_it(1000);

	}
	
	for( i = final; i>=0; i--)
	{
		Led(i);
		wait_it(1000);
	}

}

// R G B => 27 downto 16
void VGA_COLOR(int value) {
	//ALIGNEMENT DE LA VARIABLE VALUE PAR DECALAGE A GAUCHE DE X BITS
	value=value<<16;
	MemoryWrite(GPIO0_CLEAR, (~value) & 0x07FF8000); //clear => 27 downto 16
	MemoryWrite(GPIO0_OUT, value); //set
}



