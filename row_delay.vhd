----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:54:41 12/25/2017 
-- Design Name: 
-- Module Name:    row_delay - rtl 
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

entity row_delay is
    Port ( clk_100hz_i : in  STD_LOGIC;
           row_i : in  STD_LOGIC_VECTOR (3 downto 0);
           row_reg_o : out  STD_LOGIC_VECTOR (3 downto 0));
end row_delay;

architecture rtl of row_delay is

begin
  process(clk_100hz_i,row_i)
    begin
    if rising_edge(clk_100hz_i) then
      row_reg_o <= row_i;
    end if;
  end process;
end rtl;

