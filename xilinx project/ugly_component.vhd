----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:20:25 11/08/2017 
-- Design Name: 
-- Module Name:    ugly_component - Behavioral 
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

entity ugly_component is
	Port(
		-- inputs
		A : in STD_LOGIC_VECTOR (31 downto 0);
		B : in STD_LOGIC_VECTOR (31 downto 0);
		ALUop: out STD_LOGIC_VECTOR (2 downto 0)
	);
end ALU;

architecture Behavioral of ugly_component is
begin
	ugly_component:process(A,B,ALUop)
	begin
		case ALUop is
			-- ADD
			when "000" => Y <= A + B; 
			-- SUB
			when "001" => Y <= A - B; 
			-- AND
			when "010" => Y <= A and B; 
			-- OR
			when "011" => Y <= A or  B; 
			-- NOR
			when "100" => Y <= A nor A;
			-- 
			when others => Y <= (others => '0');
		end case;
	end process;
end Behavioral;

