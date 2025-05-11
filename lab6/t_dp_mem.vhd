LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.conv_integer;

ENTITY t_dp_mem IS
end t_dp_mem;

ARCHITECTURE test OF t_dp_mem IS
component dp_mem
	port (
	addra: IN std_logic_VECTOR(3 downto 0);
	addrb: IN std_logic_VECTOR(3 downto 0);
	clka: IN std_logic;
	clkb: IN std_logic;
	dina: IN std_logic_VECTOR(15 downto 0);
	dinb: IN std_logic_VECTOR(15 downto 0);
	douta: OUT std_logic_VECTOR(15 downto 0);
	doutb: OUT std_logic_VECTOR(15 downto 0);
	wea: IN std_logic;
	web: IN std_logic);
end component;

signal clka: std_logic := '0';
signal clkb: std_logic := '0';
signal addra: std_logic_VECTOR(3 downto 0);
signal addrb: std_logic_VECTOR(3 downto 0);
signal dina: std_logic_VECTOR(15 downto 0);
signal dinb: std_logic_VECTOR(15 downto 0);
signal douta: std_logic_VECTOR(15 downto 0);
signal doutb: std_logic_VECTOR(15 downto 0);
signal wea: std_logic := '0';
signal web: std_logic := '0';


begin

clka <= not clka after 5 ns;
clkb <= not clkb after 10 ns;


UUT: dp_mem port map (addra => addra,
		      addrb => addrb,
		      clka => clka,
		      clkb => clkb,
		      dina => dina,
		      dinb => dinb,
   		      douta => douta,
		      doutb => doutb,
   		      wea => wea,
		      web => web);

process
begin

-- set an address a I want to write to
addra <= "0000";

-- set data I want to write to 
dina <= "0000000000101010";

-- assert the write a flag
wea <= '1';

-- set the address for the read at b.
addrb <= "0000";

-- assert the value on the doutb flag.
wait until doutb = "0000000000101010";

wait;
end process;

end test;
