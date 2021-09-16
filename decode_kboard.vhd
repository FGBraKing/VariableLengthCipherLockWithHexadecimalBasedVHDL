----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:27:55 12/25/2017 
-- Design Name: 
-- Module Name:    decode_kboard - rtl 
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

entity decode_kboard is
    Port ( row_col_i : in  STD_LOGIC_VECTOR (7 downto 0);
           en_i : in  STD_LOGIC;
           code_o : out  STD_LOGIC_VECTOR (3 downto 0));
end decode_kboard;

architecture rtl of decode_kboard is

begin
  process(en_i,row_col_i)
  begin 
  if rising_edge(en_i) then
      case row_col_i is
        when "01110111"  => code_o <=  "0000";
        when "01111011"  => code_o <=  "0001"; 
        when "01111101"  => code_o <=  "0010"; 
        when "01111110"  => code_o <=  "0011"; 
        when "10110111"  => code_o <=  "0100"; 
        when "10111011"  => code_o <=  "0101"; 
        when "10111101"  => code_o <=  "0110"; 
        when "10111110"  => code_o <=  "0111";
        when "11010111"  => code_o <=  "1000"; 
        when "11011011"  => code_o <=  "1001"; 
        when "11011101"  => code_o <=  "1010"; 
        when "11011110"  => code_o <=  "1011"; 
        when "11100111"  => code_o <=  "1100"; 
        when "11101011"  => code_o <=  "1101"; 
        when "11101101"  => code_o <=  "1110"; 
        when "11101110"  => code_o <=  "1111";
        when others => NULL;
       end case;  
  end if;
  end process;
end rtl;

