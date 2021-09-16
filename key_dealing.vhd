----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:48:08 12/24/2017 
-- Design Name: 
-- Module Name:    key_dealing - rtl 
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

entity key_dealing is
    Port ( clk_100hz_i  : in  STD_LOGIC;
           clk_200hz_i  : in  STD_LOGIC;
           mode_i       : in  STD_LOGIC;
           enter_i      : in  STD_LOGIC;
           rst_n_i      : in  STD_LOGIC;
           pro_rst_n_i  : in  STD_LOGIC;
           col_i        : in  STD_LOGIC_VECTOR (3 downto 0);
           col_o        : out STD_LOGIC_VECTOR (3 downto 0);
           mode_o       : out  STD_LOGIC;
           enter_o      : out  STD_LOGIC;
           rst_o      : out  STD_LOGIC;
           pro_rst_o  : out  STD_LOGIC;
           key_matrix_o : out  STD_LOGIC);
end key_dealing;

architecture rtl of key_dealing is

signal s_key_matrix :std_logic :='0';

begin

	Inst_keyboard_signal_pro: keyboard_signal_pro PORT MAP(
		clk_100hz_i => clk_100hz_i,
		clk_200hz_i => clk_200hz_i,
		keyboard_button_i => col_i,
		keyboard_but_all_o => col_o,
		keyboard_button_o => s_key_matrix
	);

	Inst_clr_jitter_reg1: clr_jitter_reg PORT MAP(
		clk_100hz_i => clk_100hz_i,
		button_i => mode_i,
		button_o => mode_o,
		button_n_o => open
	);

	Inst_clr_jitter_reg2: clr_jitter_reg PORT MAP(
		clk_100hz_i => clk_100hz_i,
		button_i => enter_i,
		button_o => enter_o,
		button_n_o => open
	);

	Inst_clr_jitter_reg3: clr_jitter_reg PORT MAP(
		clk_100hz_i => clk_100hz_i,
		button_i => rst_n_i,
		button_o => rst_o,
		button_n_o => open
	);

	Inst_clr_jitter_reg4: clr_jitter_reg PORT MAP(   --50ms reg
		clk_100hz_i => clk_100hz_i,
		button_i => pro_rst_n_i,
		button_o => pro_rst_o,
		button_n_o => open
	);

	Inst_clr_jitter_reg5: clr_jitter_reg PORT MAP(   --150ms reg
		clk_100hz_i => clk_100hz_i,
		button_i => s_key_matrix,
		button_o => key_matrix_o,
		button_n_o => open
	);

end rtl;

