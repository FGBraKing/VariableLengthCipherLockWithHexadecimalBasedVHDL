----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:05:28 12/24/2017 
-- Design Name: 
-- Module Name:    keyboard_signal_pro - rtl 
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
use work.my_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard_signal_pro is
    generic(
    LOW_CNT_MAX : integer := 40); --200ms
    Port ( clk_100hz_i : in  STD_LOGIC;
           clk_200hz_i : in  STD_LOGIC;
           keyboard_button_i  : in   STD_LOGIC_VECTOR (3 downto 0);
           keyboard_but_all_o : out  STD_LOGIC_VECTOR (3 downto 0);
           keyboard_button_o  : out  STD_LOGIC);
end keyboard_signal_pro;

architecture rtl of keyboard_signal_pro is

  signal s_but      : STD_LOGIC_VECTOR (3 downto 0):="1111";
  signal s_button   : std_logic:='0';
  signal s_button_p : std_logic :='0';
  signal s_low_cnt  : integer range 0 to LOW_CNT_MAX     := 0;
  signal s_start_low_detec : std_logic :='0';

begin

	Inst_clr_jitter_reg1: clr_jitter_reg PORT MAP(
		clk_100hz_i => clk_100hz_i,
		button_i => keyboard_button_i(0),
		button_o => open,
		button_n_o => s_but(0)
	);

	Inst_clr_jitter_reg2: clr_jitter_reg PORT MAP(
		clk_100hz_i => clk_100hz_i,
		button_i => keyboard_button_i(1),
		button_o => open,
		button_n_o => s_but(1)
	);

	Inst_clr_jitter_reg3: clr_jitter_reg PORT MAP(
		clk_100hz_i => clk_100hz_i,
		button_i => keyboard_button_i(2),
		button_o => open,
		button_n_o => s_but(2)
	);
  
	Inst_clr_jitter_reg4: clr_jitter_reg PORT MAP(
		clk_100hz_i => clk_100hz_i,
		button_i => keyboard_button_i(3),
		button_o => open,
		button_n_o => s_but(3)
	);  

  keyboard_but_all_o <=s_but;           
  keyboard_button_o <=not s_button_p;   --低电平有效
  s_button <= '1' when (s_but = "1110" or s_but = "1101" or s_but ="1011" or s_but ="0111") else '0';
  
  process(s_button_p)
  begin
  if(s_button_p='1') then
    s_start_low_detec <='1';
  else 
    s_start_low_detec <='0';   
  end if;
  end process;
    
  process(s_button,s_low_cnt,s_start_low_detec,clk_200hz_i)
  begin
  if(s_start_low_detec ='0') then
    s_button_p <= s_button;
  elsif rising_edge(clk_200hz_i) then
    if(s_low_cnt = LOW_CNT_MAX) then
      s_button_p <= '0';
    end if;
  end if;
  end process;
		 
  process(clk_200hz_i, s_button, s_start_low_detec, s_low_cnt)
  begin
    if rising_edge(clk_200hz_i) then
      if (s_start_low_detec = '1' and s_button = '0') then
			    if(s_low_cnt =LOW_CNT_MAX) then
		       s_low_cnt <= 0;		
			    else
			     s_low_cnt <= s_low_cnt+1;
			    end if;
			else 
			  	s_low_cnt <= 0; 
      end if;
    end if;
  end process;
end rtl;

