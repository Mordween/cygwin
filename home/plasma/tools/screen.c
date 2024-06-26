#include "plasma.h"

#define MemoryRead(A) (*(volatile unsigned int*)(A))
#define MemoryWrite(A,V) *(volatile unsigned int*)(A)=(V)

#define max_y 640
#define max_x 480

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
void VGA_COLOR(int red, int green, int blue);
void move_x(int value);
void move_y(int value);

 
int main()
{
	int value_x = 0;
	int value_y = 0;
	puts("demarrage : \r\n");
	while(1)
	{
		
		if(BTN_R() == 1)
		{
			value_x ++;
			if(value_x >= (max_x/2))
			{
				value_x = (max_x/2);
			}
			move_x(value_x);
			puts("R \r \n");
			//VGA_COLOR(15, 0, 7);
			wait_it(10);	// anti_rebond
			Led(10);
		}
		else if(BTN_L() == 1)
		{	
			value_x --;
			if(value_x < 0)
			{
				value_x = 0;
			}
			move_x(value_x);
			puts("L \r \n");
			//VGA_COLOR(0, 7, 15);
			wait_it(10);	// anti_rebond
			Led(50);
		}
		else if(BTN_U() == 1)
		{	
			value_y --;
			puts("U \r \n");
			
			if(value_y < 0)
			{
				value_y = 0;
			}
			
			move_y(value_y);
			//VGA_COLOR(7, 7, 7);
			wait_it(10);	// anti_rebond
			Led(100);
		}
		else if(BTN_D() == 1)
		{	
			value_y ++;
			puts("D \r \n");
			if(value_y >= (max_y/3))
			{
				value_y = (max_y/3);
			}
			move_y(value_y);
			//VGA_COLOR(0, 15, 7);
			wait_it(10);	// anti_rebond
			Led(150);
		}
		else
		{
			int value = SW();
			int red;
			int green;
			int blue;
			red = (value & 0x0f00)>>8;
			green = (value & 0x00f0)>>4;
			blue = value & 0x000f;
			VGA_COLOR(red, green, blue);
			Led(value);
			
			
			
		}
	}
	
	return 0;
}


/*
 * Fonctions of test_led.c 
 *
 */
 
 void move_x(int value)	// 23-16
{
	 MemoryWrite(GPIO1_CLEAR, (~value << 16) & 0x00ff0000); //clear
	 MemoryWrite(GPIO1_OUT, (value << 16)); //Change LEDs
}

 void move_y(int value)	//31-24
{
	 MemoryWrite(GPIO1_CLEAR, (~value << 24) & 0xff000000); //clear
	 MemoryWrite(GPIO1_OUT, (value << 24)); //Change LEDs
}


 
 void SEG7b(char E4, char E3, char E2, char E1);
 
 // R G B => 27 downto 16
void VGA_COLOR(int red, int green, int blue) {
	//ALIGNEMENT DE LA VARIABLE VALUE PAR DECALAGE A GAUCHE DE X BITS
	int value=(red << 8) + (green << 4) + (blue);
	value = value << 16;
	MemoryWrite(GPIO0_CLEAR, (~value) & ((0xfff)<<16)); //clear => 27 downto 16
	MemoryWrite(GPIO0_OUT, (value)); //set
}



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
	 MemoryWrite(GPIO0_CLEAR, (~value) & 0xffff); //clear
	 MemoryWrite(GPIO0_OUT, value); //Change LEDs
}

// gpioA_in(7 downto 0) => switch(7 downto 0)
int SW(void)
{
	int valeur =  (MemoryRead(GPIOA_IN) & 0xffff);
	return valeur;
}

// gpioA_in(11) => btnR
// gpioA_in(10) => btnL
// gpioA_in(9) => btnU
// gpioA_in(8) => btnD
int BTN_R(void)
{
	if( (MemoryRead(GPIOA_IN) & (0x1<<19)) == (0x1<<19))
	{
		return 1;
	}
	return 0;
}

int BTN_L(void)
{
	if((MemoryRead(GPIOA_IN) & (0x1<<18)) == (0x1<<18))
	{
		return 1;
	}
	return 0;
}

int BTN_U(void)
{
	if((MemoryRead(GPIOA_IN) & (0x1<<17)) ==  (0x1<<17))
	{
		return 1;
	}
	return 0;
}

int BTN_D(void)
{
	if((MemoryRead(GPIOA_IN) & (0x1<<16)) == (0x1<<16))
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
