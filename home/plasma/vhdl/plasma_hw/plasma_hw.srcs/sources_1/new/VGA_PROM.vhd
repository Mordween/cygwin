
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity VGA_PROM is
Port (  hc :        in      std_logic_vector(9 downto 0);       -- signal numéro du pixel courant sur une ligne
        vc :        in      std_logic_vector(9 downto 0);       -- signal numéro de ligne courant 
        vidon :     in      std_logic;                           -- signal position courante dans une zone d'affichage ou non 
        sw :        in      std_logic_vector(7 downto 0);
        
        gpio_out :  in     std_logic_vector(27 downto 16);          -- fond
        gpio1_out : in     std_logic_vector(31 downto 16);          -- commande sprite
    
        addr1 : out std_logic_vector(15 downto 0);
        sprite1 : in std_logic_vector(11 downto 0); 
        
         
        vgaRed : out std_logic_vector(3 downto 0); 
        vgaGreen : out std_logic_vector(3 downto 0); 
        vgaBlue : out std_logic_vector(3 downto 0)    
        
);
end VGA_PROM;

architecture Behavioral of VGA_PROM is

constant hbp :      std_logic_vector(9 downto 0) := "0010010000" ;      -- hbp : back porch horizontal (= SP + BP en horizontal)*       (144)
constant vbp :      std_logic_vector(9 downto 0) := "0000011111" ;      -- vbp : back porch vertical (= SP + BP en vertical)*           (31)
constant w :        std_logic_vector(9 downto 0) := "0011110000" ;      -- w largeur du sprite (240)
constant h :        std_logic_vector(9 downto 0) := "0010100000" ;      -- h hauteur du sprite (160)

signal sprite1_on :   std_logic := '0';                                   -- indique si on se trouve dans la zone du sprite
signal xpix, ypix : std_logic_vector(9 downto 0) := (others => '0');    -- permet de repérer les coordonnées pixel du sprite  

signal temp : std_logic_vector(16 downto 0) := (others => '0');         -- valeur temporel pour le calcul de rom_addr16 



begin

ypix <= (vc - vbp) -  "11" * gpio1_out(31 downto 24); 
xpix <= (hc - hbp) - "10" * gpio1_out(23 downto 16);

adressage : process(ypix, xpix)
begin
    temp <= (ypix & "0000000") + (ypix & "000000") + (ypix & "00000") + (ypix & "0000");
    addr1 <= temp(15 downto 0) + xpix;
end process;

sprite : process(hc, vc, gpio1_out)
begin
    if(((hc >=hbp+1+ ("10" * gpio1_out(23 downto 16))) and (hc <=hbp +w + ("10" * gpio1_out(23 downto 16)))) and((vc >= vbp+1 + ("11" * gpio1_out(31 downto 24))) and (vc <= vbp + h + ("11" * gpio1_out(31 downto 24))))) then sprite1_on <= '1';
    else sprite1_on <= '0';
    end if;
end process;

RBG : process(vidon, gpio_out, sprite1_on)
begin   
    if(vidon = '1') then
        if(sprite1_on = '1') then
            vgaRed     <= sprite1(11 downto 8);
            vgaGreen   <= sprite1(7 downto 4);
            vgaBlue    <= sprite1(3 downto 0);
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
