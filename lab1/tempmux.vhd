library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TEMPMUX is
	port ( CURRENT_TEMP	: in std_logic_vector(6 downto 0);
	       DESIRED_TEMP	: in std_logic_vector(6 downto 0);
	       DISPLAY_SELECT	: in bit;
	       COOL		: in bit;
	       HEAT		: in bit;
	       A_C_ON		: out bit;
	       FURNACE_ON	: out bit;
	       TEMP_DISPLAY	: out std_logic_vector(6 downto 0));
end TEMPMUX;

architecture BEHAV of TEMPMUX is
begin

process (CURRENT_TEMP, DESIRED_TEMP, DISPLAY_SELECT)
begin

--    if to_integer(unsigned(CURRENT_TEMP)) > 70 then
--	A_C_ON <= '1';
--	FURNACE_ON <= '0';
--    else
--	A_C_ON <= '0';
--	FURNACE_ON <= '1';
--    end if;

    if COOL = '1' then
	A_C_ON <= '1';
    else
	A_C_ON <= '0';
    end if;

    if HEAT = '1' then
	FURNACE_ON <= '1';
    else
	FURNACE_ON <= '0';
    end if;

    if DISPLAY_SELECT = '1' then
	TEMP_DISPLAY <= CURRENT_TEMP;
    else
        TEMP_DISPLAY <= DESIRED_TEMP;
    end if;
end process;

end BEHAV;
