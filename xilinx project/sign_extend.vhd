----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:34:09 11/10/2017 
-- Design Name: 
-- Module Name:    sign_extend - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sign_extend is
	Port(
		input: in std_logic_vector (15 downto 0);
		output : out std_logic_vector (31 downto 0)
	);
end sign_extend;

architecture Behavioral of sign_extend is
begin
	process(input)
	begin
		case input(15) is
			when '1' => 	output <= "1111111111111111" & input; 
			when others => output <= "0000000000000000" & input;
		end case;
	end process;
end Behavioral;