----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:49:42 12/25/2017 
-- Design Name: 
-- Module Name:    keyboard_code - rtl 
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
use work.my_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard_code is
    Port ( clk_50hz_i : in  STD_LOGIC;
           clk_100hz_i : in std_logic;
           en_i : in  STD_LOGIC;
           col_i : in  STD_LOGIC_VECTOR (3 downto 0);
           row_o : out  STD_LOGIC_VECTOR (3 downto 0);
           key_code_o : out  STD_LOGIC_VECTOR (3 downto 0));
end keyboard_code;

architecture rtl of keyboard_code is

signal s_row     : STD_LOGIC_VECTOR (3 downto 0);
signal s_row_reg : STD_LOGIC_VECTOR (3 downto 0);
signal s_row_col : STD_LOGIC_VECTOR (7 downto 0);

begin

  row_o<=s_row;

	Inst_row_scan: row_scan PORT MAP(
		clk_50hz_i => clk_50hz_i,
		row_o => s_row
	);

	Inst_row_delay: row_delay PORT MAP(    --��ģ�鲻��Ҫ����Ϊʹ��100hzʱ�Ӷ�50hzʱ�Ӳ��������ź�ȥ����ֻ�ӳ���5ms�����Ǽ������������ʱ�ӷ������ң��ӳٵ�ʱ�伫��Ϊ0~10ms
		clk_100hz_i => clk_100hz_i,          --�����źŵĳ���ʱ��Ϊ20ms����������ӳ٣����ǿ��Լ�⵽��
		row_i => s_row,
		row_reg_o => s_row_reg
	);
  
	Inst_combine: combine PORT MAP(
		row_i => s_row_reg,
		col_i => col_i,
		row_col_o => s_row_col
	);  

	Inst_decode_kboard: decode_kboard PORT MAP(
		row_col_i => s_row_col,
		en_i => en_i,
		code_o => key_code_o
	);
end rtl;

