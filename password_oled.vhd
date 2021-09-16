----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:24:24 12/20/2017 
-- Design Name: 
-- Module Name:    password_oled - rtl 
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

entity password_oled is
    Port ( clk_50mhz_i : in  STD_LOGIC;
           rst_n_i : in  STD_LOGIC;
           pro_rst_n_i : in  STD_LOGIC;
           enter_i : in  STD_LOGIC;
           mode_i : in  STD_LOGIC;
           col_i : in  STD_LOGIC_VECTOR (3 downto 0);
           row_o : out  STD_LOGIC_VECTOR (3 downto 0);
           beep_o : out  STD_LOGIC;
           lcd_rs_o : out  STD_LOGIC;
           lcd_wr_o : out  STD_LOGIC;
           lcd_en_o : out  STD_LOGIC;
           lcd_data_o : out  STD_LOGIC_VECTOR (7 downto 0);
           led_o : out  STD_LOGIC_VECTOR (3 downto 0));
end password_oled;

architecture rtl of password_oled is
  signal s_clk_2hz : std_logic :='0';
  signal s_clk_50hz : std_logic :='0';
  signal s_clk_100hz : std_logic :='0';
  signal s_clk_200hz : std_logic :='0';
  signal s_clk_1mhz : std_logic :='0';

  signal s_col_cir : std_logic_vector(3 downto 0) :="1111";
  signal s_mode : std_logic :='0';
  signal s_enter : std_logic :='0';
  signal s_rst : std_logic :='0';
  signal s_pro_rst : std_logic :='0';
  signal s_key_matrix : std_logic :='0';

  signal s_code : std_logic_vector(3 downto 0)  :="0000";
  
  signal s_output :display_array :=page_block;

begin

	Inst_clk_div: clk_div PORT MAP(
		clk_50mhz_i => clk_50mhz_i,
    clk_2hz_o => s_clk_2hz,
		clk_50hz_o => s_clk_50hz,
		clk_100hz_o => s_clk_100hz,
		clk_200hz_o => s_clk_200hz,
		clk_1mhz_o => s_clk_1mhz
	);

	Inst_key_dealing: key_dealing PORT MAP(
		clk_100hz_i => s_clk_100hz,
		clk_200hz_i => s_clk_200hz,
		mode_i => mode_i,
		enter_i => enter_i,
		rst_n_i => rst_n_i,
		pro_rst_n_i => pro_rst_n_i,
		col_i => col_i,
		col_o => s_col_cir,
		mode_o => s_mode,
		enter_o => s_enter,
		rst_o => s_rst,
		pro_rst_o => s_pro_rst,
		key_matrix_o => s_key_matrix
	);

	Inst_keyboard_code: keyboard_code PORT MAP(
		clk_50hz_i => s_clk_50hz,
    clk_100hz_i => s_clk_100hz,
		en_i => s_clk_100hz,
		col_i => s_col_cir,
		row_o => row_o,
		key_code_o => s_code
	);

	Inst_lcd1602: lcd1602 PORT MAP(
		clk_1mhz_i => s_clk_1mhz,
		rst_n_i => rst_n_i,                         --对lcd1602保留异步复位键，长按rst_n_i键会导致无法显示输出，但通常不会有按着一个键一直不放的情况，除非按键损坏
		data_i => s_output,
		lcd_rs_o => lcd_rs_o,
		lcd_wr_o => lcd_wr_o,
		lcd_en_o => lcd_en_o,
		lcd_data_o =>lcd_data_o 
	);
  
	Inst_state_control: state_control PORT MAP(
		clk_2hz_i => s_clk_2hz,
		clk_100hz_i => s_clk_100hz,
		mode_i => s_mode,
		enter_i => s_enter,
		rst_i => s_rst,
		pro_rst_i => s_pro_rst,
		keyboard_i => s_key_matrix,
		key_val_i => s_code,
		led_o => led_o,
		lcd_data_o => s_output,
		beep_o => beep_o 
	);
  --译码测试
--  beep_o <= '1';
--  led_o <= not s_code;
end rtl;

