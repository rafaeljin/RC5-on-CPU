----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:16:18 11/08/2017 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	Port(
		-- inputs
		A : in STD_LOGIC_VECTOR (31 downto 0);
		B : in STD_LOGIC_VECTOR (31 downto 0);
		ALUop: in STD_LOGIC_VECTOR (2 downto 0);
		-- output flags: 
			-- overflow for signed adds and subs
			-- (no carry flag because no unsigned in NYU-6463) zero = (is 0)
		-- overflow,zero: out STD_LOGIC;
		-- ALU output
		Y : out STD_LOGIC_VECTOR (31 downto 0)
	);
end ALU;

architecture Behavioral of ALU is
begin
	ALU:process(A,B,ALUop)
	begin
		case ALUop is
			-- ADD
			when "001" => Y <= A + B; 
			-- SUB
			when "010" => Y <= A - B; 
			-- AND
			when "011" => Y <= A and B; 
			-- OR
			when "100" => Y <= A or  B; 
			-- NOR
			when "101" => Y <= A nor B;
			-- 
			when "111"=> 
			case B(4 downto 0) is
				when "00001" => Y <= '0' & A(31 downto 1);
				when "00010" => Y <= "00" & A(31 downto 2);
				when "00011" => Y <= "000" & A(31 downto 3);
				when "00100" => Y <= "0000" & A(31 downto 4);
				when "00101" => Y <= "00000" & A(31 downto 5);
				when "00110" => Y <= "000000" & A(31 downto 6);
				when "00111" => Y <= "0000000" & A(31 downto 7);
				when "01000" => Y <= "00000000" & A(31 downto 8);
				when "01001" => Y <= "000000000" & A(31 downto 9);
				when "01010" => Y <= "0000000000" & A(31 downto 10);
				when "01011" => Y <= "00000000000" & A(31 downto 11);
				when "01100" => Y <= "000000000000" & A(31 downto 12);
				when "01101" => Y <= "0000000000000" & A(31 downto 13);
				when "01110" => Y <= "00000000000000" & A(31 downto 14);
				when "01111" => Y <= "000000000000000" & A(31 downto 15);
				when "10000" => Y <= "0000000000000000" & A(31 downto 16);
				when "10001" => Y <= "00000000000000000" & A(31 downto 17);
				when "10010" => Y <= "000000000000000000" & A(31 downto 18);
				when "10011" => Y <= "0000000000000000000" & A(31 downto 19);
				when "10100" => Y <= "00000000000000000000" & A(31 downto 20);
				when "10101" => Y <= "000000000000000000000" & A(31 downto 21);
				when "10110" => Y <= "0000000000000000000000" & A(31 downto 22);
				when "10111" => Y <= "00000000000000000000000" & A(31 downto 23);
				when "11000" => Y <= "000000000000000000000000" & A(31 downto 24);
				when "11001" => Y <= "0000000000000000000000000" & A(31 downto 25);
				when "11010" => Y <= "00000000000000000000000000" & A(31 downto 26);
				when "11011" => Y <= "000000000000000000000000000" & A(31 downto 27);
				when "11100" => Y <= "0000000000000000000000000000" & A(31 downto 28);
				when "11101" => Y <= "00000000000000000000000000000" & A(31 downto 29);
				when "11110" => Y <= "000000000000000000000000000000" & A(31 downto 30);
				when "11111" => Y <= "0000000000000000000000000000000" & A(31);
				when others => Y <= A;
			end case;
				
			when "110"=> 
			case B(4 downto 0) is
				when "00001" =>  Y <= A(30 downto 0) & '0';
				when "00010" =>  Y <= A(29 downto 0) & "00";
				when "00011" =>  Y <= A(28 downto 0) & "000";
				when "00100" =>  Y <= A(27 downto 0) & "0000";
				when "00101" =>  Y <= A(26 downto 0) & "00000";
				when "00110" =>  Y <= A(25 downto 0) & "000000";
				when "00111" =>  Y <= A(24 downto 0) & "0000000";
				when "01000" =>  Y <= A(23 downto 0) & "00000000";
				when "01001" =>  Y <= A(22 downto 0) & "000000000";
				when "01010" =>  Y <= A(21 downto 0) & "0000000000";
				when "01011" =>  Y <= A(20 downto 0) & "00000000000";
				when "01100" =>  Y <= A(19 downto 0) & "000000000000";
				when "01101" =>  Y <= A(18 downto 0) & "0000000000000";
				when "01110" =>  Y <= A(17 downto 0) & "00000000000000";
				when "01111" =>  Y <= A(16 downto 0) & "000000000000000";
				when "10000" =>  Y <= A(15 downto 0) & "0000000000000000";
				when "10001" =>  Y <= A(14 downto 0) & "00000000000000000";
				when "10010" =>  Y <= A(13 downto 0) & "000000000000000000";
				when "10011" =>  Y <= A(12 downto 0) & "0000000000000000000";
				when "10100" =>  Y <= A(11 downto 0) & "00000000000000000000";
				when "10101" =>  Y <= A(10 downto 0) & "000000000000000000000";
				when "10110" =>  Y <= A(9 downto 0) & "0000000000000000000000";
				when "10111" =>  Y <= A(8 downto 0) & "00000000000000000000000";
				when "11000" =>  Y <= A(7 downto 0) & "000000000000000000000000";
				when "11001" =>  Y <= A(6 downto 0) & "0000000000000000000000000";
				when "11010" =>  Y <= A(5 downto 0) & "00000000000000000000000000";
				when "11011" =>  Y <= A(4 downto 0) & "000000000000000000000000000";
				when "11100" =>  Y <= A(3 downto 0) & "0000000000000000000000000000";
				when "11101" =>  Y <= A(2 downto 0) & "00000000000000000000000000000";
				when "11110" =>  Y <= A(1 downto 0) & "000000000000000000000000000000";
				when "11111" =>  Y <= A(0) & "0000000000000000000000000000000";
				when others => Y <= A;
			end case;
			when others => Y <= (others => 'Z');
		end case;
	end process;
end Behavioral;