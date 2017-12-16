----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:16:16 11/08/2017 
-- Design Name: 
-- Module Name:    decoder - Behavioral 
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

entity decoder is
	Port(
		-- inputs
		instruction: in STD_LOGIC_VECTOR(31 downto 0);
		-- outputs
		rs,rt,rd: out STD_LOGIC_VECTOR(4 downto 0);
		imm: out STD_LOGIC_VECTOR(15 downto 0);
		imm_j: out STD_LOGIC_VECTOR(25 downto 0);
		opcode: out STD_LOGIC_VECTOR(3 downto 0);
		funccode: out STD_LOGIC_VECTOR(2 downto 0)
	);
end decoder;

architecture Behavioral of decoder is
begin
	rs <= instruction(25 downto 21);
	rt <= instruction(20 downto 16);
	rd <= instruction(15 downto 11);
	imm <= instruction(15 downto 0);
	imm_j <= instruction(25 downto 0);
	opcode <= instruction(29 downto 26);
	funccode <= instruction(2 downto 0);
end Behavioral;
