
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity clk_div is
Port ( mclk : in std_logic;
        clk25 : out std_logic;
        rst : in std_logic       
);
end clk_div;

architecture Behavioral of clk_div is
signal compteur : std_logic_vector(23 downto 0) := (others => '0');
begin

diviser : process(mclk, rst)
begin
    if(rst = '1') then
        compteur <= (others => '0');
    elsif rising_edge(mclk) then
        compteur <= compteur +1;
    end if;
end process diviser;

clk25 <= compteur(1);    --1 pour avoir une clock de 25 Mhz

end Behavioral;