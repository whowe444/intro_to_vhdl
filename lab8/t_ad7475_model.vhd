library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned.conv_integer;

entity t_ad7475_model is
end t_ad7475_model;

architecture TEST of t_ad7475_model is
component ad7475_model is
port (SCLK	: in std_logic;
	CSN	: in std_logic;
	SDATA	: out std_logic);
end component;

signal SCLK	: std_logic := '1';
signal CSN	: std_logic := '1';
signal SDATA	: std_logic;

begin

UUT: ad7475_model
port map (SCLK	=> SCLK,
	  CSN	=> CSN,
	  SDATA	=> SDATA);

process
begin
	wait for 100ns;
	CSN <= '0';
	for i in 0 to 15 loop
		wait for 5 ns;
		SCLK <= '0';
		wait for 5 ns;
		SCLK <= '1';
	end loop;
	CSN <= '1';
end process;

end TEST;

	