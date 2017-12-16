----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:51:20 11/19/2017 
-- Design Name: 
-- Module Name:    clock_divider - Behavioral 
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity clock_div_pow2 is
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
end clock_div_pow2;

architecture rtl of clock_div_pow2 is
	signal clk_divider        : unsigned(7 downto 0);
begin
	p_clk_divider: process(i_rst,i_clk)
	begin
		if(i_rst='0') then
			clk_divider   <= (others=>'0');
		elsif(rising_edge(i_clk)) then
			clk_divider   <= clk_divider + 1;
		end if;
	end process p_clk_divider;
	
	o_clk_div2    <= clk_divider(0);
	o_clk_div4    <= clk_divider(1);
	o_clk_div8    <= clk_divider(2);
	o_clk_div16   <= clk_divider(3);
	o_clk_div32    <= clk_divider(4);
	o_clk_div64    <= clk_divider(5);
	o_clk_div128   <= clk_divider(6);
	o_clk_div256    <= clk_divider(7);
	
end rtl;