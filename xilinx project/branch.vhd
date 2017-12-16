----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:17:57 11/08/2017 
-- Design Name: 
-- Module Name:    branch - Behavioral 
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
use IEEE.STD_LOGIC_signed.ALL;   -- blt cpm signed

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity branch is 
	port(
		-- inputs
		A : in STD_LOGIC_VECTOR (31 downto 0);
		B : in STD_LOGIC_VECTOR (31 downto 0);
		opcode: in STD_LOGIC_VECTOR(3 downto 0);
		-- Branch Output
		take_branch: out STD_LOGIC
	);
end branch;


architecture Behavioral of branch is
begin
	process(A,B,opcode)
	begin
		case opcode is
			-- BLT
			when "1001" => 
				if (A < B) then take_branch <= '1';
				else take_branch <= '0';
				end if;
			-- BEQ
			when "1010" => 
				if (A = B) then take_branch <= '1';
				else take_branch <= '0';
				end if;
			-- BNE
			when "1011" => 
				if (A /= B) then take_branch <= '1';
				else take_branch <= '0';
				end if;
			when others => take_branch <= '0';
		end case;
	end process;

end Behavioral;

