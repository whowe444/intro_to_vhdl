LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.conv_integer;
use std.textio.all;
use ieee.std_logic_textio.all;

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
file pseudocode_file: text;
	variable L_IN	: line;
	variable INSTRUCTION	: string(1 to 5);
	variable DUMMY	: character;
	variable ADDR 	: std_logic_VECTOR(3 downto 0);
	variable DATA	: std_logic_VECTOR(15 downto 0);
	variable STATUS : boolean;
begin
	dina <= (others => '0');
	dinb <= (others => '0');
	wea <= '0';
	web <= '0';
	file_open(pseudocode_file,
		"dp_mem_test.txt", READ_MODE);
	wait until clkb'event and clkb = '1';
	wait until clkb'event and clkb = '1';
	wait until clkb'event and clkb = '1';
	while (INSTRUCTION /= "END  ") loop
		readline(pseudocode_file, L_IN);
		read(L_IN, INSTRUCTION);
		read(L_IN, DUMMY);
		hread(L_IN, ADDR, STATUS);
		read(L_IN, DUMMY);
		hread(L_IN, DATA, STATUS);

		case(INSTRUCTION) is
			when "WRITE" =>
				addra <= ADDR;
				dina <= DATA;
				wea <= '1';
				wait until clka'event and clka = '1';
				wea <= '0';
			when "READ " =>
				addrb <= ADDR;
				wait until clkb'event and clkb = '1';
				wait until clkb'event and clkb = '1';
				assert doutb = DATA;
			when "END  " =>
				report "End of Simulation" severity failure;
			when others =>
				report "Instruction not recognized";
		end case;
	end loop;
end process;

end test;
