
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity plasma_basys3 is
Port (  mclk        : in std_logic;
        RsRx        : in std_logic;
        RsTx        : out std_logic;   
        led         : out std_logic_vector(15 downto 0);
        btnR, btnL, btnU, btnD, btnC : in std_logic;
        sw          : in std_logic_vector(15 downto 0);
        Hsync : out std_logic; 
        Vsync : out std_logic;
        vgaRed : out std_logic_vector(3 downto 0); 
        vgaGreen : out std_logic_vector(3 downto 0); 
        vgaBlue : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(0 to 6);
        dp : out std_logic;
        an : out std_logic_vector(3 downto 0)      
);
end plasma_basys3;

architecture Behavioral of plasma_basys3 is
component plasma
generic(    memory_type : string := "XILINX_16X"; --"DUAL_PORT_" "ALTERA_LPM";
               log_file    : string := "UNUSED";
               ethernet    : std_logic := '0';
               use_cache   : std_logic := '0');
           
port(   clk          : in std_logic;
        reset        : in std_logic;

        uart_write   : out std_logic;
        uart_read    : in std_logic;

        address      : out std_logic_vector(31 downto 2);
        byte_we      : out std_logic_vector(3 downto 0); 
        data_write   : out std_logic_vector(31 downto 0);
        data_read    : in std_logic_vector(31 downto 0);
        mem_pause_in : in std_logic;
        no_ddr_start : out std_logic;
        no_ddr_stop  : out std_logic;
        
        gpio0_out    : out std_logic_vector(31 downto 0);
        gpio1_out    : out std_logic_vector(31 downto 0);
        gpioA_in     : in std_logic_vector(31 downto 0)
);
end component;

component clk_div
Port (  mclk        : in std_logic;
        clk25       : out std_logic;
        rst         : in std_logic       
);
end component;

component RAM_PROGRAM 
 PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

component VGA_640x480
PORT (
        clk25 :     in      std_logic;
        rst :       in      std_logic;
        HSYNC :     out     std_logic;                          -- signal de synchronisation horizontale
        VSYNC :     out     std_logic;                          -- signal de synchronisation verticale
        hc :        out     std_logic_vector(9 downto 0);       -- signal numéro du pixel courant sur une ligne
        vc :        out     std_logic_vector(9 downto 0);       -- signal numéro de ligne courant 
        vidon :     out     std_logic                           -- signal position courante dans une zone d'affichage ou non       
);
end component;

--component vga_color
--Port (  hc :        in     std_logic_vector(9 downto 0);       -- signal numéro du pixel courant sur une ligne
--        vc :        in     std_logic_vector(9 downto 0);       -- signal numéro de ligne courant 
--        vidon :     in     std_logic;                          -- signal position courante dans une zone d'affichage ou non
--        gpio_out :  in     std_logic_vector(27 downto 16);  
--        vgaRed : out std_logic_vector(3 downto 0); 
--        vgaGreen : out std_logic_vector(3 downto 0); 
--        vgaBlue : out std_logic_vector(3 downto 0);
             
--        sprite1 : in std_logic_vector(11 downto 0)                                
--);
--end component;

component VGA_PROM
Port (  hc :        in      std_logic_vector(9 downto 0);       -- signal numéro du pixel courant sur une ligne
        vc :        in      std_logic_vector(9 downto 0);       -- signal numéro de ligne courant 
        vidon :     in      std_logic;                           -- signal position courante dans une zone d'affichage ou non 
        sw :        in      std_logic_vector(7 downto 0);
        
        gpio_out :  in     std_logic_vector(27 downto 16);          -- fond
        gpio1_out : in std_logic_vector(31 downto 16);              -- 31-24 => Y
                                                                    -- 23-16 => X
    
        addr1 : out std_logic_vector(15 downto 0);
        sprite1 : in std_logic_vector(11 downto 0); 
        
         
        vgaRed : out std_logic_vector(3 downto 0); 
        vgaGreen : out std_logic_vector(3 downto 0); 
        vgaBlue : out std_logic_vector(3 downto 0)    
        
);
end component;

component VGA_PROM_DINO
PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
);
end component;


signal clk_25 : std_logic;
-- signal led_signal : std_logic_vector(7 downto 0); 
signal btn : std_logic_vector(3 downto 0);
-- signal switch : std_logic_vector(7 downto 0);

signal vidon    :   std_logic; 
signal hc, vc   :   std_logic_vector(9 downto 0);
signal color    :   std_logic_vector(27 downto 16);

signal zero     :   std_logic_vector(31 downto 0) := (others => '0');
signal zero0    :   std_logic_vector(31 downto 0) := (others => '0');
signal zero1    :   std_logic_vector(31 downto 0) := (others => '0');

signal data_read    :   std_logic_vector(31 downto 0);
signal address      :   std_logic_vector(31 downto 2);
signal byte_we      :   std_logic_vector(3 downto 0); 
signal data_write   :   std_logic_vector(31 downto 0);
signal mem_pause_in :   std_logic;
signal no_ddr_start :   std_logic;
signal no_ddr_stop  :   std_logic;


signal sprite1 : std_logic_vector(11 downto 0);
signal addr1 : std_logic_vector(15 downto 0);


signal gpio1_signal : std_logic_vector(31 downto 0):=(others => '0');

--gpio1_signal(31 downto 16) <= "0001111100011111";

begin


ram : RAM_PROGRAM
PORT MAP(
    addra => address(13 downto 2),
    addrb => address(13 downto 2),
    dina => data_write,
    doutb => data_read,
    clka => mclk,
    clkb => mclk,
    wea => byte_we
);



plasmaport : plasma
--    generic map(memory_type : string := "XILINX_16X"; --"DUAL_PORT_" "ALTERA_LPM";
 --          log_file    : string := "UNUSED";
 --          ethernet    : std_logic := '0';
 --          use_cache   : std_logic := '0');
           
   PORT MAP(
   clk => clk_25,
   uart_read => RsRx,
   uart_write => RsTx,
   reset => btnC,
   
   address => address,
   data_read => data_read,
   byte_we => byte_we,
   data_write => data_write,
   mem_pause_in => mem_pause_in,
   no_ddr_start => no_ddr_start,
   no_ddr_stop => no_ddr_stop,
   
   gpio0_out(31 downto 28) => zero0(31 downto 28),
   --gpio0_out(28 downto 24) => zero0(28 downto 24),
   gpio0_out(27 downto 16) => color(27 downto 16),
   gpio0_out(15 downto 0) => led(15 downto 0), -- zero0(15 downto 0), --led(15 downto 0),
   
   
   gpio1_out(31 downto 16) => gpio1_signal(31 downto 16),
   gpio1_out(15 downto 12) => zero1(15 downto 12),
   gpio1_out(6 downto 0) => seg(0 to 6),
   gpio1_out(10 downto 7) => an(3 downto 0),
   gpio1_out(11) => dp,
   
   gpioA_in(31 downto 20) => zero(31 downto 20),
   gpioA_in(19) => btnR,
   gpioA_in(18) => btnL,
   gpioA_in(17) => btnU,
   gpioA_in(16) => btnD,
   gpioA_in(15 downto 0) => sw(15 downto 0)
   
);

clk : clk_div
port map(
    mclk => mclk,
    clk25 => clk_25,
    rst => btnC

);

vga_controler :
VGA_640x480 port map( 
    clk25 => clk_25,
    rst => btnC,
    HSYNC => Hsync,
    VSYNC => Vsync,
    vidon => vidon,
    hc => hc, 
    vc => vc
);


--color_control : 
--VGA_PROM port map(
--    hc => hc,
--    vc => vc,
--    vidon => vidon,
--    vgaRed => vgaRed,
--    vgaGreen => vgaGreen,
--    vgaBlue => vgaBlue,
--    gpio_out(27 downto 16) => color(27 downto 16),
    
--    sprite1 => sprite1
--);
ram_dino : VGA_PROM_DINO
Port map(
    clka => mclk,           -- IN
    addra => addr1,         -- IN
    douta => sprite1        -- OUT
);
 
VGA_control : VGA_PROM 
port map(
    hc => hc,
    vc => vc,
    vidon => vidon,
    vgaRed => vgaRed,
    vgaGreen => vgaGreen,
    vgaBlue => vgaBlue,
    
    sw(7 downto 0) => sw(7 downto 0),
    
    gpio_out(27 downto 16) => color(27 downto 16),
    
    gpio1_out(31 downto 16) => gpio1_signal(31 downto 16),
    
    sprite1 => sprite1,     -- IN
    addr1 => addr1          -- OUT
);


end Behavioral;
