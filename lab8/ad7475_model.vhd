library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned.conv_integer;

entity ad7475_model is
port (SCLK	: in std_logic;
	CSN	: in std_logic;
	SDATA	: out std_logic);
end ad7475_model;

architecture model of ad7475_model is
signal ad_val : std_logic_vector(15 downto 0) := "0000000000000001";
begin

process
variable bit_num : integer;
begin
	wait until csn'event and csn='0';
	bit_num := 15;
	sdata <= 'U';
	while (csn = '0' and bit_num >= 0) loop
		sdata <= ad_val(bit_num);
		bit_num := bit_num - 1;
	end loop;
	ad_val <= ad_val + 1;
	ad_val(15 downto 12) <= "0000";
end process;

end model;