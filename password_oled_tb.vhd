--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:14:14 12/26/2017
-- Design Name:   
-- Module Name:   E:/FPGALABS/The last/code/password_oled_tb.vhd
-- Project Name:  password_oled
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: password_oled
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY password_oled_tb IS
END password_oled_tb;
 
ARCHITECTURE behavior OF password_oled_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT password_oled
    PORT(
         clk_50mhz_i : IN  std_logic;
         rst_n_i : IN  std_logic;
         pro_rst_n_i : IN  std_logic;
         enter_i : IN  std_logic;
         mode_i : IN  std_logic;
         col_i : IN  std_logic_vector(3 downto 0);
         row_o : OUT  std_logic_vector(3 downto 0);
         beep_o : OUT  std_logic;
         lcd_rs_o : OUT  std_logic;
         lcd_wr_o : OUT  std_logic;
         lcd_en_o : OUT  std_logic;
         lcd_data_o : OUT  std_logic_vector(7 downto 0);
         led_o : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_50mhz_i : std_logic := '0';
   signal rst_n_i : std_logic := '1';
   signal pro_rst_n_i : std_logic := '1';
   signal enter_i : std_logic := '1';
   signal mode_i : std_logic := '1';
   signal col_i : std_logic_vector(3 downto 0) := (others => '1');

 	--Outputs
   signal row_o : std_logic_vector(3 downto 0);
   signal beep_o : std_logic;
   signal lcd_rs_o : std_logic;
   signal lcd_wr_o : std_logic;
   signal lcd_en_o : std_logic;
   signal lcd_data_o : std_logic_vector(7 downto 0);
   signal led_o : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_50mhz_i_period : time := 0.02 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: password_oled PORT MAP (
          clk_50mhz_i => clk_50mhz_i,
          rst_n_i => rst_n_i,
          pro_rst_n_i => pro_rst_n_i,
          enter_i => enter_i,
          mode_i => mode_i,
          col_i => col_i,
          row_o => row_o,
          beep_o => beep_o,
          lcd_rs_o => lcd_rs_o,
          lcd_wr_o => lcd_wr_o,
          lcd_en_o => lcd_en_o,
          lcd_data_o => lcd_data_o,
          led_o => led_o
        );

   -- Clock process definitions
   clk_50mhz_i_process :process
   begin
		clk_50mhz_i <= '0';
		wait for clk_50mhz_i_period/2;
		clk_50mhz_i <= '1';
		wait for clk_50mhz_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_50mhz_i_period*10;

      -- insert stimulus here 
      col_i <= "1111";
      wait for 50 us;    
      col_i <= "1110";--1
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";--2
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";--3
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";--4
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";--5
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";
      wait for 20 us;
      col_i <= "1111";
      wait for 60 us;
      col_i <= "1110";--6
      wait for 20 us;
      col_i <= "1111";
      wait for 100 us;
      mode_i <='0';
      wait for 500 us;
      mode_i <= '1';
      wait for 100 us;
      enter_i <='0';
      wait for 500 us;
      enter_i <= '1';
      wait for 100 us;
      pro_rst_n_i <='0';
      wait for 500 us;
      pro_rst_n_i <= '1';
      wait for 100 us;
      rst_n_i <='0';
      wait for 500 us;
      rst_n_i <= '1';
   
      wait;
   end process;

END;
