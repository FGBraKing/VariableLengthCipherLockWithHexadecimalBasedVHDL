----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:59:31 12/25/2017 
-- Design Name: 
-- Module Name:    row_scan - rtl 
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

entity row_scan is
    Port ( clk_50hz_i : in  STD_LOGIC;
           row_o : out  STD_LOGIC_VECTOR (3 downto 0));
end row_scan;

architecture rtl of row_scan is

  signal s_cnt : integer range 0 to 3 :=0;

begin
  process(clk_50hz_i,s_cnt)
  begin
    if rising_edge(clk_50hz_i) then
      if(s_cnt <3) then
        s_cnt <= s_cnt +1;
      else
        s_cnt <=0;
      end if;
    end if;
  end process;
  
  process(s_cnt)
  begin
    case s_cnt is
    when 0      => row_o <= "1110";
    when 1      => row_o <= "1101";
    when 2      => row_o <= "1011";
    when 3      => row_o <= "0111";
    when others => row_o <= "1110";
    end case;
  end process;
  
end rtl;

