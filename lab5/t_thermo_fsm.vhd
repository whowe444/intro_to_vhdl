library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_THERMO_FSM is
end T_THERMO_FSM;

architecture TEST of T_THERMO_FSM is
component THERMO_FSM is
	port ( CLK		: in std_logic;
	       RESET	        : in std_logic;
	       CURRENT_TEMP	: in std_logic_vector(6 downto 0);
	       DESIRED_TEMP	: in std_logic_vector(6 downto 0);
	       DISPLAY_SELECT	: in std_logic;
	       COOL		: in std_logic;
	       HEAT		: in std_logic;
	       FURNACE_HOT      : in std_logic;
	       AC_READY		: in std_logic;
	       AC_ON		: out std_logic;
	       FURNACE_ON	: out std_logic;
	       FAN_ON		: out std_logic;
	       TEMP_DISPLAY	: out std_logic_vector(6 downto 0));
end component;

signal CLK : std_logic := '0';
signal RESET : std_logic := '0';
signal CURRENT_TEMP, DESIRED_TEMP : std_logic_vector(6 downto 0) := "0000000";
signal TEMP_DISPLAY : std_logic_vector(6 downto 0);
signal DISPLAY_SELECT : std_logic := '0';
signal COOL : std_logic := '0';
signal HEAT : std_logic := '0';
signal FURNACE_HOT : std_logic := '0';
signal AC_READY : std_logic := '0';
signal AC_ON : std_logic := '0';
signal FURNACE_ON : std_logic := '0';
signal FAN_ON : std_logic := '0';

begin

CLK <= not CLK after 5 ns;

UUT: THERMO_FSM port map (
		       CURRENT_TEMP => CURRENT_TEMP,
                       DESIRED_TEMP => DESIRED_TEMP,
                       DISPLAY_SELECT => DISPLAY_SELECT, 
                       TEMP_DISPLAY => TEMP_DISPLAY,
    		       AC_ON => AC_ON,
  		       FURNACE_ON => FURNACE_ON,
		       FAN_ON => FAN_ON,
		       COOL => COOL,
		       HEAT => HEAT,
		       FURNACE_HOT => FURNACE_HOT,
		       AC_READY => AC_READY,
	               CLK => CLK,
    		       RESET => RESET);
                       
process
begin

CURRENT_TEMP <= "0000000";
DESIRED_TEMP <= "1111111";
DISPLAY_SELECT <= '1';
wait until TEMP_DISPLAY = "1111111";

HEAT <= '1';
FURNACE_HOT <= '0';

wait until FURNACE_ON = '1';
assert AC_ON = '0' report "AC_ON not 0";
assert FAN_ON = '0' report "FAN_ON not 0";

FURNACE_HOT <= '1';
wait until FAN_ON = '1';
assert FURNACE_ON = '1';
assert AC_ON = '0';

HEAT <= '0';
wait until FURNACE_ON = '0';
assert AC_ON = '0';
assert FAN_ON = '1';

CURRENT_TEMP <= "1111111";
DESIRED_TEMP <= "0000000";
wait for 25 ns;
assert FURNACE_ON = '0';
assert AC_ON = '0';
assert FAN_ON = '1';

HEAT <= '1';
wait for 25 ns;
assert FURNACE_ON = '0';
assert AC_ON = '0';
assert FAN_ON = '1';

-- return back to idle --
FURNACE_HOT <= '0';
wait until FAN_ON = '0';
assert FURNACE_ON = '0';
assert AC_ON = '0';

COOL <= '1';
HEAT <= '0';
wait until AC_ON = '1';
assert FURNACE_ON = '0';
assert FAN_ON = '0';

AC_READY <= '1';
wait until FAN_ON = '1';
assert FURNACE_ON = '0';
assert AC_ON = '1';

CURRENT_TEMP <= "0000000";
DESIRED_TEMP <= "1111111";
wait until AC_ON = '0';
assert FURNACE_ON = '0';
assert FAN_ON = '1';

COOL <= '0';
wait for 25 ns;
assert FURNACE_ON = '0';
assert AC_ON = '0';
assert FAN_ON = '1';

-- return back to idle --
AC_READY <= '0';
wait until FAN_ON = '0';
assert FURNACE_ON = '0';
assert AC_ON = '0';

wait;
end process;

end TEST;