----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:57:13 12/27/2017 
-- Design Name: 
-- Module Name:    bcd2lcddata - rtl 
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

entity bcd2lcddata is
    Port ( led_i : in  STD_LOGIC_VECTOR (3 downto 0);
           lcddata : out  STD_LOGIC_VECTOR (7 downto 0));
end bcd2lcddata;

architecture rtl of bcd2lcddata is

begin
  process(led_i)
  begin
    case led_i is
    when "0000" => lcddata <= x"30";
    when "0001" => lcddata <= x"31";
    when "0010" => lcddata <= x"32";
    when "0011" => lcddata <= x"33";
    when "0100" => lcddata <= x"34";
    when "0101" => lcddata <= x"35";
    when "0110" => lcddata <= x"36";
    when "0111" => lcddata <= x"37";
    when "1000" => lcddata <= x"38";
    when "1001" => lcddata <= x"39";
    when "1010" => lcddata <= x"61";
    when "1011" => lcddata <= x"62";
    when "1100" => lcddata <= x"63";
    when "1101" => lcddata <= x"64";
    when "1110" => lcddata <= x"65";
    when "1111" => lcddata <= x"66";
    when others => null;
    end case;   
    end process;
end rtl;

