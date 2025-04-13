library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TEMPMUX is
	port ( CLK		: in std_logic;
	       CURRENT_TEMP	: in std_logic_vector(6 downto 0);
	       DESIRED_TEMP	: in std_logic_vector(6 downto 0);
	       DISPLAY_SELECT	: in bit;
	       COOL		: in bit;
	       HEAT		: in bit;
	       A_C_ON		: out bit;
	       FURNACE_ON	: out bit;
	       TEMP_DISPLAY	: out std_logic_vector(6 downto 0));
end TEMPMUX;

architecture BEHAV of TEMPMUX is
signal CURRENT_TEMP_REG : std_logic_vector(6 downto 0);
signal DESIRED_TEMP_REG : std_logic_vector(6 downto 0);
signal DISPLAY_SELECT_REG : bit;
signal COOL_REG : bit;
signal HEAT_REG : bit;

begin

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

process (CLK)
begin
    if rising_edge(CLK) then
	    if to_integer(unsigned(CURRENT_TEMP_REG)) > to_integer(unsigned(DESIRED_TEMP_REG)) and COOL_REG = '1' then
	 	A_C_ON <= '1';
	    else
		A_C_ON <= '0';
	    end if;

	    if to_integer(unsigned(CURRENT_TEMP_REG)) < to_integer(unsigned(DESIRED_TEMP_REG)) and HEAT_REG = '1' then
	 	FURNACE_ON <= '1';
	    else
		FURNACE_ON <= '0';
	    end if;
    end if;

end process;

process (CLK)
begin
    if rising_edge(CLK) then
	-- register inputs
   	CURRENT_TEMP_REG <= CURRENT_TEMP;
	DESIRED_TEMP_REG <= DESIRED_TEMP;
	DISPLAY_SELECT_REG <= DISPLAY_SELECT;
	COOL_REG <= COOL;
	HEAT_REG <= HEAT;
    end if;
end process;

end BEHAV;
