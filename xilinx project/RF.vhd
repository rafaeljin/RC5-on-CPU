LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; --use CONV_INTEGER

-- 32 registers, each 32 bits 
ENTITY RF IS
PORT(
	-- clock and signal
	clk,regwrite: IN STD_LOGIC;
	-- register number
	writereg,readreg1,readreg2: in std_logic_vector(4 downto 0);
	-- data
	datain: in STD_LOGIC_VECTOR(31 DOWNTO 0) ;
	dataout1,dataout2: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	readreg3: in std_logic_vector(4 downto 0);
	dataout3: out std_logic_vector(31 DOWNTO 0)
	);
END RF;

ARCHITECTURE Behavioral OF RF IS
	TYPE register_array IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal my_RF: register_array := (
		X"00000000",   -- 0
		X"00000000",	-- 1
		X"9a42bd8a",   -- 2
		X"60b0bfbb",   -- 3
		X"00000000",   -- 4
		X"00000000",   -- 5
		X"00000000",   -- 6
		X"00000000",   -- 7
		X"00000000",   -- 8
		X"00000000",   -- 9
		X"80000000",   -- 10
		X"00000000",	-- 11
		X"9a42bd8a",   -- 12
		X"60b0bfbb",   -- 13
		X"00000000",   -- 14
		X"00000000",   -- 15
		X"00000000",   -- 16
		X"00000000",   -- 17
		X"00000000",   -- 18
		X"00000000",   -- 19
		X"80000000",   -- 20
		X"00000000",	-- 21
		X"9a42bd8a",   -- 22
		X"60b0bfbb",   -- 23
		X"00000000",   -- 24
		X"00000000",   -- 25
		X"00000000",   -- 26
		X"00000000",   -- 27
		X"00000000",   -- 28
		X"00000000",   -- 29
		X"80000000",   -- 30
		X"00000001",   -- 31

		others => (others => '0') );
BEGIN
	
	write_reg: PROCESS(clk,writereg,datain,regwrite)
	BEGIN
		-- instead of rising edge we use the falling edge
		IF(clk'EVENT AND clk='0') THEN
			if (regwrite ='1') then my_RF(CONV_INTEGER(writereg)) <= datain; end if;
		END IF;
	END PROCESS;
	
	dataout1 <= my_RF(CONV_INTEGER(readreg1));
	dataout2 <= my_RF(CONV_INTEGER(readreg2));
	dataout3 <= my_RF(CONV_INTEGER(readreg3));
END Behavioral;