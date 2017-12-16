LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; --use CONV_INTEGER

-- 32 registers, each 32 bits 
ENTITY DM IS
PORT(
	-- clock and signal
	clk,memwrite: in STD_LOGIC;
	-- input address
	addr: in std_logic_vector(31 downto 0);
	-- data
	datain: in STD_LOGIC_VECTOR(31 downto 0) ;
	dataout: out STD_LOGIC_VECTOR(31 downto 0);
	addr2: in std_logic_vector(31 downto 0);
	dataout2: out STD_LOGIC_VECTOR(31 downto 0);
	dm_init: in std_logic;
	init_value: in std_logic_vector(223 downto 0)
	);
END DM;

-- big endian
ARCHITECTURE Behavioral OF DM IS
	TYPE my_array IS ARRAY (0 TO 159) OF STD_LOGIC_VECTOR(7 downto 0);
	signal data_memory: my_array :=( others=>(others=>'0') );
	attribute ram_style: string;
	attribute ram_style of data_memory: signal is "block";
	
BEGIN
	
	-- assume little endian
	write_reg: PROCESS(clk,dm_init,init_value,datain,memwrite,addr)
	begin
		if (dm_init = '0') then
			data_memory(8) <= "11111111";
			data_memory(104) <= init_value(223 downto 216); data_memory(105) <= init_value(215 downto 208);
			data_memory(106) <= init_value(207 downto 200); data_memory(107) <= init_value(199 downto 192);
			data_memory(108) <= init_value(191 downto 184); data_memory(109) <= init_value(183 downto 176);
			data_memory(110) <= init_value(175 downto 168); data_memory(111) <= init_value(167 downto 160);
			data_memory(112) <= init_value(159 downto 152); data_memory(113) <= init_value(151 downto 144);
			data_memory(114) <= init_value(143 downto 136); data_memory(115) <= init_value(135 downto 128);
			data_memory(116) <= init_value(127 downto 120); data_memory(117) <= init_value(119 downto 112);
			data_memory(118) <= init_value(111 downto 104); data_memory(119) <= init_value(103 downto 96);
			data_memory(120) <= init_value(95 downto 88);   data_memory(121) <= init_value(87 downto 80);
			data_memory(122) <= init_value(79 downto 72);   data_memory(123) <= init_value(71 downto 64);
			data_memory(124) <= init_value(63 downto 56);   data_memory(125) <= init_value(55 downto 48);
			data_memory(126) <= init_value(47 downto 40);   data_memory(127) <= init_value(39 downto 32);
			data_memory(128) <= init_value(31 downto 24);	data_memory(129) <= init_value(23 downto 16);
			data_memory(130) <= init_value(15 downto 8);    data_memory(131) <= init_value(7 downto 0);

		-- instead of rising edge we use the falling edge
		else
			if(clk'EVENT AND clk='0') then
				if (memwrite ='1') then 
					data_memory(CONV_INTEGER(addr)) <= datain(31 downto 24);
					data_memory(CONV_INTEGER(addr)+1) <= datain(23 downto 16);
					data_memory(CONV_INTEGER(addr)+2) <= datain(15 downto 8);
					data_memory(CONV_INTEGER(addr)+3) <= datain(7 downto 0);				
				end if;
			end if;
		end if;
		
		
		
	END PROCESS;
	
	read: process(addr,data_memory)	
	begin
		if (addr < X"0000009d") then
			dataout <= 	data_memory(CONV_INTEGER(addr)) &
							data_memory(CONV_INTEGER(addr)+1) &
							data_memory(CONV_INTEGER(addr)+2) &
							data_memory(CONV_INTEGER(addr)+3);
		else
			dataout <= (others => '0');
		end if;
	end process;
	
	read2: process(addr2,data_memory)	
	begin
		if (addr < X"0000009d") then
			dataout2 <= 	data_memory(CONV_INTEGER(addr2)) &
							data_memory(CONV_INTEGER(addr2)+1) &
							data_memory(CONV_INTEGER(addr2)+2) &
							data_memory(CONV_INTEGER(addr2)+3);
		else
			dataout2 <= (others => '0');
		end if;
	end process;	

END Behavioral;