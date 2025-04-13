library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

entity THERMO_FSM is
	port ( CLK		: in std_logic;
	       RESET	        : in std_logic;
	       CURRENT_TEMP	: in std_logic_vector(6 downto 0);
	       DESIRED_TEMP	: in std_logic_vector(6 downto 0);
	       DISPLAY_SELECT	: in std_logic;
	       COOL		: in std_logic;
	       HEAT		: in std_logic;
	       FURNACE_HOT      : in std_logic;
	       AC_READY		: in std_logic;
	       AC_ON		: out std_logic := '0';
	       FURNACE_ON	: out std_logic := '0';
	       FAN_ON		: out std_logic := '0';
	       TEMP_DISPLAY	: out std_logic_vector(6 downto 0));
end THERMO_FSM;

architecture BEHAV of THERMO_FSM is

-- state machine type definition --
type STATE_TYPE is (IDLE, COOLON, ACNOWREADY, ACDONE, HEATON, FURNACENOWHOT, FURNACECOOL);
signal CURRENT_STATE : STATE_TYPE := IDLE;
signal NEXT_STATE    : STATE_TYPE := IDLE;
signal COUNTDOWN : std_logic_vector(4 downto 0);

-- registered inputs --
signal CURRENT_TEMP_REG : std_logic_vector(6 downto 0);
signal DESIRED_TEMP_REG : std_logic_vector(6 downto 0);
signal DISPLAY_SELECT_REG : std_logic := '0';
signal COOL_REG : std_logic := '0';
signal HEAT_REG : std_logic := '0';
signal FURNACE_HOT_REG : std_logic := '0';
signal AC_READY_REG : std_logic := '0';

begin

-- process for registering outputs --
process (CLK, RESET)
begin
	if RESET = '1' then
		FURNACE_ON <= '0';
		AC_ON <= '0';
		FAN_ON <= '0';
	elsif rising_edge(CLK) then
		case NEXT_STATE is
			when IDLE =>
				FURNACE_ON <= '0';
				AC_ON <= '0';
				FAN_ON <= '0';
			when COOLON =>
				FURNACE_ON <= '0';
				AC_ON <= '1';
				FAN_ON <= '0';
			when ACNOWREADY =>
				FURNACE_ON <= '0';
				AC_ON <= '1';
				FAN_ON <= '1';
			when ACDONE =>
				FURNACE_ON <= '0';
				AC_ON <= '0';
				FAN_ON <= '1';
			when HEATON =>
				FURNACE_ON <= '1';
				AC_ON <= '0';
				FAN_ON <= '0';
 			when FURNACENOWHOT =>
				FURNACE_ON <= '1';
				AC_ON <= '0';
				FAN_ON <= '1';
			when FURNACECOOL =>
				FURNACE_ON <= '0';
				AC_ON <= '0';
				FAN_ON <= '1';
			when others =>
				-- same selections as "IDLE" state
				FURNACE_ON <= '0';
				AC_ON <= '0';
				FAN_ON <= '0';
		end case;
	end if;
end process;

-- process for advancing STATE on each CLK
process (CLK, RESET)
begin
	if RESET = '1' then
		CURRENT_STATE <= IDLE;
	elsif rising_edge(CLK) then
		CURRENT_STATE <= NEXT_STATE;
	end if;
end process;

-- process for registering TEMP_DISPLAY output --
process (CLK)
begin
    if rising_edge(CLK) then
	    if DISPLAY_SELECT_REG = '1' then
		TEMP_DISPLAY <= CURRENT_TEMP;
	    else
	        TEMP_DISPLAY <= DESIRED_TEMP;
	    end if;
    end if;
end process;

-- process for defining behavior (transitions) of the state machine --
process (CURRENT_STATE, CURRENT_TEMP_REG, DESIRED_TEMP_REG, COOL_REG, HEAT_REG, FURNACE_HOT_REG, AC_READY_REG, COUNTDOWN)
begin
	case CURRENT_STATE is
		when IDLE =>
			if to_integer(unsigned(CURRENT_TEMP_REG)) > to_integer(unsigned(DESIRED_TEMP_REG)) and COOL_REG = '1' then
				NEXT_STATE <= COOLON;
			elsif to_integer(unsigned(CURRENT_TEMP_REG)) < to_integer(unsigned(DESIRED_TEMP_REG)) and HEAT_REG = '1' then
				NEXT_STATE <= HEATON;
			else
				NEXT_STATE <= IDLE;
			end if;
		when COOLON =>
			if AC_READY_REG = '1' then
				NEXT_STATE <= ACNOWREADY;
			else
				NEXT_STATE <= COOLON;
			end if;
		when ACNOWREADY =>
			if not (to_integer(unsigned(CURRENT_TEMP_REG)) > to_integer(unsigned(DESIRED_TEMP_REG)) and COOL_REG = '1') then
				NEXT_STATE <= ACDONE;
			else
				NEXT_STATE <= ACNOWREADY;
			end if;
		when ACDONE =>
			if AC_READY_REG = '0'  and COUNTDOWN = 0 then
				NEXT_STATE <= IDLE;
			else
				NEXT_STATE <= ACDONE;
			end if;
		when HEATON =>
			if FURNACE_HOT_REG = '1' then
				NEXT_STATE <= FURNACENOWHOT;
			else
				NEXT_STATE <= HEATON;
			end if;
		when FURNACENOWHOT =>
			if not (to_integer(unsigned(CURRENT_TEMP_REG)) < to_integer(unsigned(DESIRED_TEMP_REG)) and HEAT_REG = '1') then
				NEXT_STATE <= FURNACECOOL;
			else
				NEXT_STATE <= FURNACENOWHOT;
			end if;
		when FURNACECOOL =>
			if FURNACE_HOT_REG = '0' and COUNTDOWN = 0 then
				NEXT_STATE <= IDLE;
			else
				NEXT_STATE <= FURNACECOOL;
			end if;
		when others =>
			NEXT_STATE <= IDLE;
	end case;
end process;

-- process for registering inputs --
process (CLK)
begin
    if rising_edge(CLK) then
   	CURRENT_TEMP_REG <= CURRENT_TEMP;
	DESIRED_TEMP_REG <= DESIRED_TEMP;
	DISPLAY_SELECT_REG <= DISPLAY_SELECT;
	COOL_REG <= COOL;
	HEAT_REG <= HEAT;
	FURNACE_HOT_REG <= FURNACE_HOT;
	AC_READY_REG <= AC_READY;
    end if;
end process;

-- process for countdown --
process(CLK)
begin
	if rising_edge(CLK) then
		if NEXT_STATE = FURNACENOWHOT then
			COUNTDOWN <= "01010";
		elsif NEXT_STATE = ACNOWREADY then
			COUNTDOWN <= "10100";
		elsif NEXT_STATE = FURNACECOOL or NEXT_STATE = ACDONE then
			COUNTDOWN <= COUNTDOWN - 1;
		end if;
	end if;
end process;

end BEHAV;
