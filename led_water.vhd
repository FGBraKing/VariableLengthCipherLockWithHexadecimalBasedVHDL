----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:20:18 12/27/2017 
-- Design Name: 
-- Module Name:    led_water - rtl 
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
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_water is
    Port ( clk_2hz_i : in  STD_LOGIC;
           led_o : out  STD_LOGIC_VECTOR (3 downto 0));
end led_water;

architecture rtl of led_water is

signal s_cnt : integer range 0 to 15:=0;

begin
  process(clk_2hz_i,s_cnt)
  begin
    if rising_edge(clk_2hz_i) then
      if(s_cnt < 15) then
        s_cnt <= s_cnt+1;
      else
        s_cnt <= 0;
      end if;
    end if;
  end process;
  
  process(s_cnt)
  begin
  case s_cnt is
  when 0  => led_o<="0111";
  when 1  => led_o<="1011";
  when 2  => led_o<="1101";
  when 3  => led_o<="1110";
  when 4  => led_o<="1110";
  when 5  => led_o<="1101";
  when 6  => led_o<="1011";
  when 7  => led_o<="0111";
  when 8  => led_o<="1001";
  when 9  => led_o<="0110";
  when 10 => led_o<="0110";
  when 11 => led_o<="1001";
  when 12 => led_o<="0110";
  when 13 => led_o<="1001";
  when 14 => led_o<="1001";
  when 15 => led_o<="0110";
  when others => led_o<=(others =>'0');
  end case;
  end process;

end rtl;

