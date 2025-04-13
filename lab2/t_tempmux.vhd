library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_TEMPMUX is
end T_TEMPMUX;

architecture TEST of T_TEMPMUX is
component TEMPMUX
	port ( CURRENT_TEMP	: in std_logic_vector(6 downto 0);
	       DESIRED_TEMP	: in std_logic_vector(6 downto 0);
	       DISPLAY_SELECT	: in bit;
	       COOL		: in bit;
	       HEAT		: in bit;
	       A_C_ON		: out bit;
	       FURNACE_ON	: out bit;
	       TEMP_DISPLAY	: out std_logic_vector(6 downto 0));
end component;

signal CURRENT_TEMP, DESIRED_TEMP : std_logic_vector(6 downto 0) := "0000000";
signal TEMP_DISPLAY : std_logic_vector(6 downto 0);
signal DISPLAY_SELECT : bit;
signal COOL : bit;
signal HEAT : bit;
signal A_C_ON : bit;
signal FURNACE_ON : bit;

begin

UUT: TEMPMUX port map (CURRENT_TEMP => CURRENT_TEMP,
                       DESIRED_TEMP => DESIRED_TEMP,
                       DISPLAY_SELECT => DISPLAY_SELECT, 
                       TEMP_DISPLAY => TEMP_DISPLAY,
    		       A_C_ON => A_C_ON,
  		       FURNACE_ON => FURNACE_ON,
			COOL => COOL,
			HEAT => HEAT);
                       
process
begin

CURRENT_TEMP <= "0000000";
DESIRED_TEMP <= "1111111";
DISPLAY_SELECT <= '0';
wait for 10 ns;
DISPLAY_SELECT <= '1';
wait for 10 ns;

HEAT <= '1';
wait for 10 ns;
assert FURNACE_ON = '1';

HEAT <= '0';
wait for 10 ns;
assert FURNACE_ON = '0';

CURRENT_TEMP <= "1111111";
DESIRED_TEMP <= "0000000";
wait for 10 ns;
assert FURNACE_ON = '0';
HEAT <= '1';
wait for 10 ns;
assert FURNACE_ON = '0';

COOL <= '0';
wait for 10 ns;
assert A_C_ON = '0';

COOL <= '1';
wait for 10 ns;
assert A_C_ON = '1';

CURRENT_TEMP <= "0000000";
DESIRED_TEMP <= "1111111";
wait for 10 ns;
assert A_C_ON = '0';

COOL <= '0';
wait for 10 ns;
assert A_C_ON = '0';

wait;
end process;

end TEST;