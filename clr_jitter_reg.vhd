----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:24:45 12/24/2017 
-- Design Name: 
-- Module Name:    clr_jitter_reg - rtl 
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

--供低电平有效的按键信号去抖
entity clr_jitter_reg is
    Port ( clk_100hz_i : in  STD_LOGIC;
           button_i   : in  STD_LOGIC;
           button_o   : out  STD_LOGIC;
           button_n_o : out  STD_LOGIC);
end clr_jitter_reg;

architecture rtl of clr_jitter_reg is
  signal x          : std_logic := '0';  
  signal y          : std_logic := '0';  
begin
process(clk_100hz_i, button_i, x)
  begin
    if rising_edge(clk_100hz_i) then
      x <= button_i;
      y <= x;
    end if;
  end process;
  
  button_o <= (not x) and y;  
  button_n_o <= not((not x) and y);

end rtl;

