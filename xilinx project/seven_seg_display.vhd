library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seven_seg_led is
port (
	clk100mhz: in std_logic;
	din: in std_logic_vector(31 downto 0);
	
	seg_output: out std_logic_vector (6 downto 0);
	led_selector: out std_logic_vector (7 downto 0)
);
end seven_seg_led;

architecture Behavioral of seven_seg_led is
	signal clock_count: std_logic_vector(20 downto 0) := (others => '0');
	signal bcd: std_logic_vector(3 downto 0) :="0000";
	signal count: std_logic_vector(2 downto 0);

begin	
	count_update:process(clk100mhz)
	begin
		if (clk100mhz'event and clk100mhz='1') then
			clock_count <= clock_count + '1';
		end if;
	end process;
	
	count <= clock_count(20 downto 18);
	
	bcd_update:process(count,din)
	begin
		case count is 
			when "000" => 
				bcd <= din(3 downto 0);
				led_selector <= "11111110";
			when "001" => 
				bcd <= din(7 downto 4);
				led_selector <= "11111101";
			when "010" => 
				bcd <= din(11 downto 8);
				led_selector <= "11111011";
			when "011" => 
				bcd <= din(15 downto 12);
				led_selector <= "11110111";
			when "100" => 
				bcd <= din(19 downto 16);
				led_selector <= "11101111";
			when "101" => 
				bcd <= din(23 downto 20);
				led_selector <= "11011111";
			when "110" => 
				bcd <= din(27 downto 24);
				led_selector <= "10111111";
			when "111" => 
				bcd <= din(31 downto 28);
				led_selector <= "01111111";
			when others => 
				bcd <= (others => '0');
				led_selector <= "11111111";
		end case;
	end process;
	
	process (bcd)
	begin
		case  bcd is
		when "0000"=> seg_output <="1000000";  -- '0'
		when "0001"=> seg_output <="1111001";  -- '1'
		when "0010"=> seg_output <="0100100";  -- '2'
		when "0011"=> seg_output <="0110000";  -- '3'
		when "0100"=> seg_output <="0011001";  -- '4' 
		when "0101"=> seg_output <="0010010";  -- '5'
		when "0110"=> seg_output <="0000010";  -- '6'
		when "0111"=> seg_output <="1111000";  -- '7'
		when "1000"=> seg_output <="0000000";  -- '8'
		when "1001"=> seg_output <="0010000";  -- '9'
		when "1010"=> seg_output <="0001000";  -- 'A'
		when "1011"=> seg_output <="0000011";  -- 'b'
		when "1100"=> seg_output <="1000110";	-- 'C'
		when "1101"=> seg_output <="0100001";	-- 'd'
		when "1110"=> seg_output <="0000110";	-- 'E'
		when "1111"=> seg_output <="0001110";	-- 'F'
		when others=> seg_output <="1111111"; 
		end case;
		
	end process;

end Behavioral;