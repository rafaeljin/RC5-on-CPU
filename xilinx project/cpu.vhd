library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity CPU is
	port(
		-- user inputs
		sw: in std_logic_vector(15 downto 0);
		btnu, btnd, btnl, btnr,btnc: in std_logic;
		-- general inputs
		clk100mhz, cpu_resetn: in std_logic;
		-- control outputs
		seven_seg: out std_logic_vector (6 downto 0);
		led: out std_logic_vector (15 downto 0);
		led_selector: out std_logic_vector (7 downto 0)
		-- memory controls
	);
end CPU;

architecture Behavioral of CPU is
	-- components
	component sign_extend
	Port(
		input: in std_logic_vector (15 downto 0);
		output : out std_logic_vector (31 downto 0)
	);
	end component;
	
	component ALU
	Port(
		-- inputs
		A : in STD_LOGIC_VECTOR (31 downto 0);
		B : in STD_LOGIC_VECTOR (31 downto 0);
		ALUop: in STD_LOGIC_VECTOR (2 downto 0);
		-- output
		Y : out STD_LOGIC_VECTOR (31 downto 0)
	);
	end component;
	
	component branch
	port(
		-- inputs
		A : in STD_LOGIC_VECTOR (31 downto 0);
		B : in STD_LOGIC_VECTOR (31 downto 0);
		opcode: in STD_LOGIC_VECTOR(3 downto 0);
		-- Branch Output
		take_branch: out STD_LOGIC
	);
	end component;
	
	component decoder
	port(
		-- inputs
		instruction: in STD_LOGIC_VECTOR(31 downto 0);
		-- outputs
		rs,rt,rd: out STD_LOGIC_VECTOR(4 downto 0);
		imm: out STD_LOGIC_VECTOR(15 downto 0);
		imm_j: out STD_LOGIC_VECTOR(25 downto 0);
		opcode: out STD_LOGIC_VECTOR(3 downto 0);
		funccode: out STD_LOGIC_VECTOR(2 downto 0)
	);
	end component;
	
	component control_unit
	port(
		-- inputs
		opcode: in STD_LOGIC_VECTOR(3 downto 0);
		funccode: in STD_LOGIC_VECTOR(2 downto 0);
		rt,rd: in STD_LOGIC_VECTOR (4 downto 0);
		-- outputs
		aluop: out STD_LOGIC_VECTOR(2 downto 0);
		regdst: out STD_LOGIC_VECTOR(4 downto 0);
		memtoreg,memwrite,isbranch,alusrc,regwrt,isjump,ishalt: out STD_LOGIC
	);
	end component;
	
	component RF
	port(
		-- clock and signal
		clk,regwrite: IN STD_LOGIC;
		-- register number
		writereg,readreg1,readreg2: in std_logic_vector(4 downto 0);
		-- data
		datain: in STD_LOGIC_VECTOR(31 DOWNTO 0) ;
		dataout1,dataout2: out STD_LOGIC_VECTOR(31 DOWNTO 0);
		readreg3: in std_logic_vector(4 downto 0);
		dataout3: out STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	end component;

	component IM
	port(
		pc: in std_logic_vector(31 downto 0);
		inst: out STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	end component;
	
	component DM
	port(
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
	end component;
	
	component seven_seg_led 
	port (
		clk100mhz : in std_logic;
		din: in std_logic_vector(31 downto 0);
		seg_output: out std_logic_vector (6 downto 0);
		led_selector: out std_logic_vector (7 downto 0)
	);
	end component;
	
	component clock_div_pow2
	port(
		i_clk         : in  std_logic;
		i_rst         : in  std_logic;
		o_clk_div2    : out std_logic;
		o_clk_div4    : out std_logic;
		o_clk_div8    : out std_logic;
		o_clk_div16   : out std_logic;
		o_clk_div32   : out std_logic;
		o_clk_div64   : out std_logic;
		o_clk_div128  : out std_logic;
		o_clk_div256   : out std_logic);
	end component;
	
	component debouncer
	port (
		clk100mhz:in std_logic;
		bin: in std_logic;
		bout: out std_logic);
	end component;

	signal LEDresult:std_logic_vector(31 downto 0);
	
	signal pc: std_logic_vector(31 downto 0) := X"00000264";
	signal nextpc,pcplus4: std_logic_vector(31 downto 0) := (others => '0');
	signal inst: std_logic_vector(31 downto 0);
	signal rs,rt,rd,RFwriteregister: STD_LOGIC_VECTOR(4 downto 0);
	signal imm: STD_LOGIC_VECTOR(15 downto 0);
	signal imm_j: STD_LOGIC_VECTOR(25 downto 0);

	signal B,ALUresult,imm32: std_logic_vector (31 downto 0);
	signal opcode: std_logic_vector(3 downto 0);
	signal funccode: std_logic_vector(2 downto 0);
	signal ALUop: std_logic_vector(2 downto 0);
	signal memtoreg,memwrite,isbranch,alusrc,regwrt,takebranch,isjump,ishalt: STD_LOGIC;
	
	signal RFwrite,RFread1,RFread2,DMresult: std_logic_vector (31 downto 0);
	
	signal count: std_logic_vector(31 downto 0);
	signal break_point: std_logic_vector(31 downto 0):= X"00008000";
	signal fivesec: std_logic:='0';
	signal slow_clock,my_clock: std_logic;
	
	signal 	pre_center_button,center_button,
				pre_up_button,up_button,
				pre_down_button,down_button,
				pre_left_button,left_button,
				pre_right_button,right_button,
				left_and_up_button: std_logic:='0';
				
	signal debugreg: std_logic_vector(4 downto 0);
	signal debugregvalue: std_logic_vector(31 downto 0);
	signal debugmem: std_logic_vector(31 downto 0);
	signal debugmemvalue: std_logic_vector(31 downto 0);

	signal dm_init: std_logic:='0';
	signal dm_init_value: std_logic_vector(223 downto 0):= (others => '0');
	-- input state machine
	signal input_count : std_logic_vector(3 downto 0);
	
	
begin
	
	-- seven-segment displays
	ss_led: seven_seg_led port map (clk100mhz,LEDresult,seven_seg,led_selector);
	-- ALU
	ALU_comp: ALU port map(RFread1,B,ALUop,ALUresult);
	-- BRANCH
	branch_comp: branch port map(RFread1,RFread2,opcode,takebranch);
	-- DECODER
	decoder_comp: decoder port map(inst,rs,rt,rd,imm,imm_j,opcode,funccode);
	-- Control Unit
	control_unit_comp: control_unit port map(opcode,funccode,rt,rd,ALUop,
		RFwriteregister,memtoreg,memwrite,isbranch,alusrc,regwrt,isjump,ishalt);
	-- register component
	rf_comp: RF port map(my_clock,regwrt,RFwriteregister,rs,rt,RFwrite,RFread1,RFread2,debugreg,debugregvalue);
	-- inst memory component
	im_comp: IM port map(pc,inst);
	-- data memory component
	dm_comp: DM port map(my_clock,memwrite,ALUresult,RFread2, DMresult,debugmem,debugmemvalue,dm_init,dm_init_value);--cpu_resetn,dm_init_value);
	-- sign_extend
	sign_extend_comp: sign_extend port map(imm,imm32);
	
	debugreg <= sw(4 downto 0);
	debugmem(31 downto 16) <= (others => '0');
	debugmem(15 downto 0) <= sw;
	led <= dm_init_value(10 downto 0) & input_count & dm_init;
	
	-- debouncers
	debounce_center_button: debouncer port map(clk100mhz,btnc,center_button);
	debounce_right_button: debouncer port map(clk100mhz,btnr,right_button);
	debounce_left_button: debouncer port map(clk100mhz,btnl,left_button);
	debounce_up_button: debouncer port map(clk100mhz,btnu,up_button);
	debounce_down_button: debouncer port map(clk100mhz,btnd,down_button);
	clock_generator: clock_div_pow2 port map(i_clk=>clk100mhz,i_rst=>cpu_resetn,o_clk_div128=>slow_clock);
	
	left_and_up_button <= left_button and up_button;
	
	stateFSM:process(left_and_up_button,cpu_resetn)
	begin
		if (cpu_resetn = '0') then
			input_count <= (others => '0');
			dm_init_value <= (others => '0');
		elsif(left_and_up_button'event and left_and_up_button = '1') then
			if (input_count < "1110") then 
				input_count <= input_count + '1';
				dm_init_value <= dm_init_value(207 downto 0) & sw;
			end if;
		end if;
	end process;
	
	outputFSM: process(input_count,cpu_resetn)
	begin
		if (cpu_resetn = '0') then
			dm_init <= '0';
		elsif (input_count = "1110") then
			dm_init <= '1';
		end if;
	end process;
	
	my_clock_update: process(right_button,left_button,center_button,slow_clock)
	begin
		if (left_button = '1' and right_button = '1') then
			my_clock <= slow_clock;
		else
			my_clock <= center_button;
		end if;
	end process;
	
	
	
--	pc_update: process(my_clock,cpu_resetn)
--	begin 
--		if (cpu_resetn = '0') then
--			pc <= X"00000264";
--		else
--			if(my_clock'event and my_clock = '1') then
--				if (break_point /= pc) then
--					pc <= nextpc;
--				end if;
--			end if;
--		end if;
--	end process;
	
	pc_update: process(slow_clock,cpu_resetn)
	begin 
		if (cpu_resetn = '0') then
				pc <= X"00000264";
		elsif(slow_clock'event and slow_clock = '1') then
			if (left_button = '1') then
					if (right_button = '1' and pc /= break_point) then
						pc <= nextpc;
					end if;
			else
				-- center button: advance pc
				if (center_button /= pre_center_button) then
					if (center_button ='1') then
						pc <= nextpc;
					end if;
					pre_center_button <= center_button;
				end if;
				
			end if;
		end if;
	end process;
	
	pcplus4(31 downto 2) <= pc(31 downto 2) + '1';
	
	pcnext_update: process(pcplus4,takebranch,imm32,inst,ishalt,isjump,pc)
	begin
		if (isjump = '1') then
			nextpc <= pcplus4(31 downto 28) & inst(25 downto 0) & "00";
		elsif (takebranch = '1') then 
			nextpc <= pcplus4 + (imm32(29 downto 0)&"00");
		elsif (ishalt = '1') then  -- not halt
			nextpc <= pc;
		else
			nextpc <= pcplus4;
		
		end if;
	end process;

	ALUsrcB_update: process(alusrc,RFread2,imm32)
	begin
		case alusrc is 
		when '0' => B <= RFread2;
		when others => B <= imm32;
		end case;
	end process;
	
	RFwrite_update: process(memtoreg,ALUresult,DMresult)
	begin
		if (memtoreg = '1') then
			RFwrite <= DMresult;
		elsif (memtoreg = '0') then
			RFwrite <= ALUresult;
		end if;
	end process;
	
	set_breakpoint: process(left_button,down_button)
	begin
		if(left_button = '1' and down_button = '1') then
			break_point(15 downto 0) <= sw;
		end if;
	end process;
	
	display_update: process(clk100mhz,cpu_resetn)
	begin
		if(clk100mhz'event and clk100mhz = '1') then
			if (cpu_resetn = '0') then
				LEDresult <= (others => '0');
			else
				--LEDresult <= dm_init_value(191 downto 164) & input_count;
				if(btnl = '0' and btnu = '1') then
					LEDresult <= debugregvalue;
				elsif(btnl = '0' and btnd = '1') then
					LEDresult <= debugmemvalue;
				elsif(btnl = '0' and btnr = '1') then
					LEDresult <= inst;
				else
					LEDresult <= pc;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

