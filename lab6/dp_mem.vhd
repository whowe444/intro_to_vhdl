LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.conv_integer;

ENTITY dp_mem IS
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
END dp_mem;

architecture RTL of dp_mem IS

type MEMTYPE is array(15 downto 0) of std_logic_vector(15 downto 0);
signal DPMEM : MEMTYPE;
signal addraint,addrbint : integer range 0 to 15;

begin

addraint <= conv_integer(addra);
addrbint <= conv_integer(addrb);

process(clka)
begin
	if clka'event and clka = '1' then
		if wea = '1' then
			DPMEM(addraint) <= dina;
		end if;
	end if;
end process;

process(clkb)
begin
	if clkb'event and clkb = '1' then
		doutb <= DPMEM(addrbint);
	end if;
end process;

end RTL;