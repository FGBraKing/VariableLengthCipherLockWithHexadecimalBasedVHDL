----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:12:06 12/25/2017 
-- Design Name: 
-- Module Name:    combine - rtl 
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

entity combine is
    Port ( row_i : in  STD_LOGIC_VECTOR (3 downto 0);
           col_i : in  STD_LOGIC_VECTOR (3 downto 0);
           row_col_o : out  STD_LOGIC_VECTOR (7 downto 0));
end combine;

architecture rtl of combine is

begin
  process(row_i,col_i)
  begin
    row_col_o <= row_i&col_i;
  end process;

end rtl;

