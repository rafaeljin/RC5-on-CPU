----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:23:20 11/08/2017 
-- Design Name: 
-- Module Name:    control_unit - Behavioral 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
	Port(
		-- inputs
		opcode: in STD_LOGIC_VECTOR(3 downto 0);
		funccode: in STD_LOGIC_VECTOR(2 downto 0);
		rt,rd: in STD_LOGIC_VECTOR (4 downto 0);
		-- outputs
		aluop: out STD_LOGIC_VECTOR(2 downto 0);
		regdst: out STD_LOGIC_VECTOR(4 downto 0);
		memtoreg,memwrite,isbranch,alusrc,regwrt,isjump,ishalt: out STD_LOGIC
	);
end control_unit;

architecture Behavioral of control_unit is
begin
	memwrite_update: process(opcode)
	begin
		if (opcode = "1000") then memwrite <= '1';
		else memwrite <= '0'; 
		end if;
	end process;

	memtoreg_update: process(opcode)
	begin
		if (opcode = "0111") then memtoreg <= '1';
		else memtoreg <= '0'; 
		end if;
	end process;
	
	isbranch_update: process(opcode)
	begin
		if (opcode = "1001" or 
			 opcode = "1010" or 
			 opcode = "1011") 
				then isbranch <= '1';
		else isbranch <= '0'; 
		end if;
	end process;
	
	isjump_update: process(opcode)
	begin
		if (opcode = "1100") then isjump <= '1';
		else isjump <= '0'; 
		end if;
	end process;
	
	ishalt_update: process(opcode)
	begin
		if (opcode = "1111") then ishalt <= '1';
		else ishalt <= '0'; 
		end if;
	end process;
	
	regwrt_update: process(opcode)
	begin
		if (opcode < "1000") then regwrt <= '1';
		else regwrt <= '0'; end if;
	end process;
	
	regdst_update:process(opcode,rt,rd)
	begin
	if (opcode = "0000") then regdst <= rd;
		else regdst <= rt; end if;
	end process;
	
	aluop_update:process(opcode,funccode)
	begin
	if (opcode = "0000") then aluop <= funccode + '1';
	elsif (opcode = "0111" or opcode = "1000") then aluop <= "001"; 
	elsif (opcode = "0101" or opcode = "0110") then aluop <= opcode(2 downto 0) + '1';
	else aluop <= opcode(2 downto 0); end if;
	end process;
	
	alusrc_update:process(opcode)
	begin
	if (opcode = "0000") then alusrc <= '0';
	else alusrc <= '1'; end if;
	end process;
	
end Behavioral;
