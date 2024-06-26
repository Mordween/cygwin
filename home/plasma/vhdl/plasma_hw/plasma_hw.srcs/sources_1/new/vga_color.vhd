
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity vga_color is
Port (  hc :        in     std_logic_vector(9 downto 0);       -- signal numéro du pixel courant sur une ligne
        vc :        in     std_logic_vector(9 downto 0);       -- signal numéro de ligne courant 
        vidon :     in     std_logic;                          -- signal position courante dans une zone d'affichage ou non
        gpio_out :  in     std_logic_vector(27 downto 16);
        
        
        sprite1_on : in std_logic; 
        sprite1 : in std_logic_vector(11 downto 0); 
        
         
        vgaRed : out std_logic_vector(3 downto 0); 
        vgaGreen : out std_logic_vector(3 downto 0); 
        vgaBlue : out std_logic_vector(3 downto 0)                                  
);
end vga_color;


architecture Behavioral of vga_color is
begin

RBG : process(vidon, gpio_out, sprite1_on)
begin   
    if(vidon = '1') then
        if(sprite1_on = '1') then
            vgaRed     <= sprite1(11 downto 8);
            vgaGreen   <= sprite1(7 downto 4);
            vgaBlue    <= sprite1(3 downto 4);
        else
            vgaRed     <= gpio_out(27 downto 24);
            vgaGreen   <= gpio_out(23 downto 20);
            vgaBlue    <= gpio_out(19 downto 16);
        end if;
    else 
        vgaRed     <= "0000";
        vgaGreen   <= "0000";
        vgaBlue    <= "0000";
    end if;

end process;


end Behavioral;
