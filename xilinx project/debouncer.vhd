----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:55:54 11/18/2017 
-- Design Name: 
-- Module Name:    debouncer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
port (
	clk100mhz:in std_logic;
	bin: in std_logic;
	bout: out std_logic);
end debouncer;

architecture Behavioral of debouncer is
	signal button: std_logic:= '0';
begin
	process(clk100mhz,button)
		variable oldb: std_logic := '1';
		variable count: std_logic_vector(19 downto 0);
	begin 
		if(clk100mhz'event and clk100mhz = '1') then
			if(bin /= oldb) then
				count := (others => '0');
				oldb := bin;
			else 
				count := count + '1';
				if (count=X"fffff" and oldb = bin) then
					button <= oldb;
				end if;
				
			end if;
		end if;
	end process;
	bout <= button;
end Behavioral;

