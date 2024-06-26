
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity VGA_640x480 is
Port (  clk25 :     in      std_logic;
        rst :       in      std_logic;
        HSYNC :     out     std_logic;                          -- signal de synchronisation horizontale
        VSYNC :     out     std_logic;                          -- signal de synchronisation verticale
        hc :        out     std_logic_vector(9 downto 0);       -- signal numéro du pixel courant sur une ligne
        vc :        out     std_logic_vector(9 downto 0);       -- signal numéro de ligne courant 
        vidon :     out     std_logic                           -- signal position courante dans une zone d'affichage ou non       
);
end VGA_640x480;

architecture Behavioral of VGA_640x480 is

--Calcul du timing horizontal
--Pixel clock = 25 MHz à Pixel time = 0,04 µs
--SP = 96 pixels x 0,04 µs = 3,84 µs
--BP = 48 pixels x 0,04 µs = 1,92 µs
--HV = 640 pixels x 0,04 µs = 25,6 µs
--FP = 16 pixels x 0,04 µs = 0,64 µs

--Calcul du timing vertical
--Pixel clock = 25 MHz à durée de la ligne horizontale = 32 µs
--SP = 2 lignes x 32 µs = 64 µs
--BP = 29 lignes x 32 µs = 928 µs
--VV = 480 lignes x 32 µs = 15,36 ms
--FP = 10 lignes x 32 µs = 320 µs

constant hbp :      std_logic_vector(9 downto 0) := "0010010000" ;      -- hbp : back porch horizontal (= SP + BP en horizontal)*       (144)
constant hfp :      std_logic_vector(9 downto 0) := "1100010000" ;      -- hfp : front porch horizontal (= SP + BP + HV en horizontal)* (784)
constant hpixels :  std_logic_vector(9 downto 0) := "1100100000" ;      -- hpixels : nombre de pixels (total) sur une ligne             (800)
constant vbp :      std_logic_vector(9 downto 0) := "0000011111" ;      -- vbp : back porch vertical (= SP + BP en vertical)*           (31)
constant vfp :      std_logic_vector(9 downto 0) := "0111111111" ;      -- vfp : front porch vertical (= SP + BP + VV en vertical)*     (511)
constant vlines :   std_logic_vector(9 downto 0) := "1000001001" ;      -- vlines : nombre de lignes (total) par frame                  (521)


signal compteur_h : std_logic_vector(9 downto 0) := (others => '0');
signal compteur_v : std_logic_vector(9 downto 0) := (others => '0');
signal vsenable : std_logic := '0';


begin

compteur_horizontale : process(clk25, rst)
begin
        if rst = '1' THEN
            compteur_h <= (others => '0');
        elsif rising_edge(clk25) THEN
            if (compteur_h = hpixels-1) then
                compteur_h <= (others => '0'); 
            else
                compteur_h <= compteur_h + 1;
            end if;
        end if;
end process;

enable : process(compteur_h)
begin
    if(compteur_h = hpixels-1) then
        vsenable <= '1';
    else
        vsenable <= '0';
    end if;
end process;

compteur_verticale : process(clk25, rst)
begin
        if rst = '1' THEN
            compteur_v <= (others => '0');
        elsif rising_edge(clk25) THEN
            if(vsenable = '1') then 
                if (compteur_v = vlines-1) then
                    compteur_v <= (others => '0'); 
                else
                    compteur_v <= compteur_v + 1;
                end if;
            end if;
        end if;
end process;



process(compteur_h, compteur_v)
begin
    if(compteur_h <= 96) then
        HSYNC <= '0';
        else HSYNC <= '1';
    end if;
    
    if(compteur_v <= 2) then
        VSYNC <= '0';
    else VSYNC <= '1';
    end if;
    
    if(compteur_h >= hbp AND compteur_h < hfp AND compteur_v >= vbp AND compteur_v < vfp) then
        vidon <= '1';
    else vidon <= '0';
    end if;

end process;

hc <= compteur_h;
vc <= compteur_v;

end Behavioral;
