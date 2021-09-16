----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:21:41 12/26/2017 
-- Design Name: 
-- Module Name:    state_control - rtl 
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

entity state_control is
    Port ( clk_2hz_i : in  STD_LOGIC;
           clk_100hz_i : in  STD_LOGIC;
           mode_i : in  STD_LOGIC;
           enter_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           pro_rst_i : in  STD_LOGIC;
           keyboard_i : in  STD_LOGIC;
           key_val_i : in  STD_LOGIC_VECTOR (3 downto 0);
           led_o : out  STD_LOGIC_VECTOR (3 downto 0);
           lcd_data_o :out display_array;
           beep_o : out  STD_LOGIC);
end state_control;

architecture rtl of state_control is

  type state is (nomal, try , pre_setup, setup, unlock, alarm);
  signal pr_state, nx_state : state := nomal;

  signal s_cnt_error : integer range 0 to 3 := 0;
  signal s_label_right  : std_logic :='0';
  signal s_error_display : std_logic :='0';
  
  signal s_password     : password_type := default_password;
  signal s_input_word   : password_type := default_input;
  
  signal s_success_led  : std_logic_vector(3 downto 0) :="0000";
  
  SIGNAL s_lcddata    : std_logic_vector(7 downto 0) := x"00";
  signal s_page_error : display_array :=page_error;
  signal s_page_input : display_array :=page_input;
  signal s_page_setup : display_array :=page_setup;
  
  signal s_eq  : std_logic :='0';
  signal s_ueq : std_logic :='1';
  
  signal s_cnt_error_display : integer range 0 to 3 :=0;
begin

  fsm_lowersection:process(clk_100hz_i)
                    begin
                    if rising_edge(clk_100hz_i) then
                      pr_state <= nx_state;
                    end if;
                   end process;
               
fsm_uppersection:process(pr_state, mode_i, enter_i, rst_i, pro_rst_i, keyboard_i, s_cnt_error, s_label_right)
                  begin
                  case pr_state is
                  when nomal =>
                    if(mode_i='1' or enter_i='1' or rst_i='1' or pro_rst_i='1' or keyboard_i='1') then
                      nx_state <= try;
                    else 
                      nx_state <= nomal; 
                    end if;
                  when try =>
                    if(pro_rst_i = '1') then
                      nx_state <= unlock;
                    elsif(rst_i = '1') then
                      nx_state <= try;
                    elsif(mode_i = '1') then
                      nx_state <=pre_setup;
                    elsif(enter_i = '1') then
                      if(s_label_right = '1') then
                        nx_state <= unlock;
                      elsif(s_cnt_error < 3) then
                        nx_state <= try;
                      else 
                        nx_state <= alarm;
                      end if;
                    else 
                      nx_state <= try;
                    end if;
                  when alarm =>
                    if(pro_rst_i = '1') then
                      nx_state <= nomal;
                    else
                      nx_state <= alarm;
                    end if;
                  when unlock =>
                    if(mode_i = '1') then
                      nx_state <= setup;
                    elsif(enter_i='1' or rst_i='1' or pro_rst_i='1' or keyboard_i='1') then
                      nx_state <= nomal;
                    else 
                      nx_state <= unlock;
                    end if;
                  when pre_setup =>
                    if(pro_rst_i = '1') then
                      nx_state <= setup;
                    elsif(rst_i = '1') then
                      nx_state <= pre_setup;
                    elsif(mode_i = '1') then
                      nx_state <= nomal;
                    elsif(enter_i ='1') then
                      if(s_label_right = '1') then
                        nx_state <= setup;
                      elsif(s_cnt_error < 3) then
                        nx_state <= pre_setup;
                      else 
                        nx_state <= alarm;
                      end if;
                    else
                      nx_state <= pre_setup;
                    end if;
                  when setup =>
                    if(pro_rst_i = '1' or enter_i = '1') then
                      nx_state <= nomal;
                    else
                      nx_state <= setup;
                    end if;
                  when others => nx_state <= nomal;
                  end case;                
                 end process;      

fsm_ouput_ledandbeep:process(pr_state,s_cnt_error,clk_2hz_i,s_success_led)  --led_o and beep_o
                      begin
                        case pr_state is
                        when nomal =>
                        led_o <= "0000";
                        beep_o <= '1';
                        when try =>
                        beep_o <= '1';
                        led_o <= "1111";
                        if (s_cnt_error >0) then
                         led_o <=not conv_std_logic_vector(s_cnt_error,4);
                        else 
                         led_o(2) <=clk_2hz_i;
                        end if;
                        when alarm =>
                          beep_o <= clk_2hz_i;
                          led_o <="1111";
                        when unlock =>
                          beep_o <= '1';
                          led_o <= s_success_led;
                        when pre_setup =>
                          beep_o <= '1';
                          led_o <= "1111";
                          if (s_cnt_error >0) then
                            led_o <=not conv_std_logic_vector(s_cnt_error,4);
                          else 
                            led_o(1) <=clk_2hz_i;
                          end if;                         
                        when setup =>
                          beep_o <= '1';
                          led_o <="1111";
                          led_o(0) <= clk_2hz_i;
                        when others => 
                          beep_o <= clk_2hz_i;
                          led_o <="1111";
                        end case; 
                      end process;     

--  s_output_lcd
fsm_ouput_lcddata:process(pr_state,s_error_display,s_page_error,s_page_setup,s_page_input)  --led_o and beep_o
                  begin
                    case pr_state is
                    when nomal =>
                      lcd_data_o <=page_nomal;
                    when try =>
                      if(s_error_display ='1') then
                        lcd_data_o <= s_page_error;
                      else      
                        lcd_data_o <=s_page_input;
                      end if;
                    when alarm =>
                      lcd_data_o <=page_illegal;
                    when unlock =>
                      lcd_data_o <=page_success;
                    when pre_setup =>
                      if(s_error_display ='1') then
                        lcd_data_o <= s_page_error;
                      else 
                        lcd_data_o <=s_page_input;
                      end if;
                    when setup =>
                      lcd_data_o <=s_page_setup;
                    when others => 
                      lcd_data_o <=page_block;
                    end case; 
                  end process;
                  
--
--s_cnt_error s_label_right s_success_led s_error_display s_page_error s_page_setup s_page_input

--s_success_led
	Inst_led_water: led_water PORT MAP(     
		clk_2hz_i => clk_2hz_i,
		led_o => s_success_led
	);

process(pr_state,clk_100hz_i,pro_rst_i,enter_i,s_input_word,s_password,s_cnt_error)
begin
  if rising_edge(clk_100hz_i) then
    if(pr_state = try or pr_state = pre_setup) then
      if(pro_rst_i='1') then
        s_cnt_error <=0;
      elsif(enter_i = '1') then
        if (s_ueq ='1') then
          s_cnt_error <= s_cnt_error+1;
          if(s_cnt_error >=3) then
            s_cnt_error<=0;
          end if;
        end if;
      end if;
    elsif(pr_state =setup or pr_state = unlock) then
      s_cnt_error <=0;
    elsif(pr_state=alarm) then
      if(pro_rst_i ='1') then
        s_cnt_error <=0;
      end if;
    end if;
  end if;
end process;

-- s_label_right s_error_display s_page_error s_page_setup s_page_input s_password s_input_word

 process(clk_100hz_i,pr_state,enter_i,pro_rst_i,s_input_word)
 begin
  if rising_edge(clk_100hz_i) then
    if(pr_state = setup) then
      if(enter_i = '1') then
        s_password <=s_input_word;
      elsif(pro_rst_i = '1') then
        s_password <=default_password;
      end if;
    end if;
  end if;
 end process;

  process(clk_100hz_i,keyboard_i,pr_state,rst_i,pro_rst_i,enter_i,s_input_word(0))                       --矩阵键盘按键次数记录
  begin
    if(pr_state=try or pr_state=pre_setup or pr_state=setup) then
      if rising_edge(clk_100hz_i) then
        if(rst_i='1' or pro_rst_i ='1' or enter_i ='1') then
          s_input_word(0) <="0000";
        elsif (keyboard_i='1') then
          s_input_word(0) <= s_input_word(0) + "0001";
        end if;
      end if;
    else
        s_input_word(0) <="0000";
    end if;
  end process;
  
  process(clk_100hz_i,keyboard_i, key_val_i,pr_state)                       
  begin
    if(pr_state=try or pr_state=pre_setup or pr_state=setup) then
      if rising_edge(clk_100hz_i) then
        if (keyboard_i='1') then
          case s_input_word(0) is
          when "0000" => s_input_word(1 ) <=key_val_i;
          when "0001" => s_input_word(2 ) <=key_val_i;
          when "0010" => s_input_word(3 ) <=key_val_i;
          when "0011" => s_input_word(4 ) <=key_val_i;
          when "0100" => s_input_word(5 ) <=key_val_i;
          when "0101" => s_input_word(6 ) <=key_val_i;
          when "0110" => s_input_word(7 ) <=key_val_i;
          when "0111" => s_input_word(8 ) <=key_val_i;
          when "1000" => s_input_word(9 ) <=key_val_i;
          when "1001" => s_input_word(10) <=key_val_i;
          when "1010" => s_input_word(11) <=key_val_i;
          when "1011" => s_input_word(12) <=key_val_i;
          when "1100" => s_input_word(13) <=key_val_i;
          when "1101" => s_input_word(14) <=key_val_i;
          when "1110" => s_input_word(15) <=key_val_i;
      --    when "1111" => s_input_word(16) <=key_val_i;
          when others => NULL;
          end case;     
        end if;
      end if;
    end if;
  end process;
     
--s_label_right s_error_display s_page_error s_page_setup s_page_input  

	Inst_compare_password: compare_password PORT MAP(
		input_paaaword => s_input_word,
		real_password => s_password,
		eq => s_eq,
		ueq => s_ueq
	);



 process(pr_state,enter_i,s_input_word,s_password)
 begin
  s_label_right <='0';
  if(pr_state = pre_setup or pr_state = try) then
    if(enter_i = '1') then
      if (s_eq = '1') then
        s_label_right <='1' ;
      end if;
    end if;
  end if;
 end process;

process(pr_state,enter_i,s_input_word,s_password,s_cnt_error_display)
begin
  if(pr_state = pre_setup or pr_state = try) then
    if(s_cnt_error_display >= 3) then
      s_error_display <= '0';
    elsif rising_edge(enter_i) then
      if (s_ueq='1') then
        s_error_display <='1';
      else 
        s_error_display <='0';
      end if;
    end if;
  else
    s_error_display <='0';
  end if;
end process;         
 
process(clk_2hz_i,s_error_display,s_cnt_error_display) 
begin
  if(s_error_display = '1') then
    if rising_edge(clk_2hz_i) then
      if(s_cnt_error_display < 3) then
        s_cnt_error_display <= s_cnt_error_display+1;
      else
        s_cnt_error_display <= 0;
      end if;
    end if;
  else
    s_cnt_error_display <= 0;
  end if;
end process;
       
 --s_page_error s_page_setup s_page_input      
     
  --lcd   
	Inst_bcd2lcddata: bcd2lcddata PORT MAP(
		led_i => key_val_i,
		lcddata =>s_lcddata 
	);
  
  process(s_cnt_error)
  begin
    s_page_error <=page_error;
    s_page_error(23) <= "00110000" or conv_std_logic_vector(s_cnt_error,8); 
  end process;   
  
  process(pr_state,s_lcddata,s_input_word(0),keyboard_i) 
  begin
    if(pr_state=setup) then
      if rising_edge(clk_100hz_i) then
        if(keyboard_i='1') then  
          case s_input_word(0) is
          when "0000" => s_page_setup(16) <=s_lcddata; s_page_setup(17 to 31) <= page_block(17 to 31); 
          when "0001" => s_page_setup(17) <=s_lcddata; s_page_setup(18 to 31) <= page_block(18 to 31); 
          when "0010" => s_page_setup(18) <=s_lcddata; s_page_setup(19 to 31) <= page_block(19 to 31); 
          when "0011" => s_page_setup(19) <=s_lcddata; s_page_setup(20 to 31) <= page_block(20 to 31); 
          when "0100" => s_page_setup(20) <=s_lcddata; s_page_setup(21 to 31) <= page_block(21 to 31); 
          when "0101" => s_page_setup(21) <=s_lcddata; s_page_setup(22 to 31) <= page_block(22 to 31); 
          when "0110" => s_page_setup(22) <=s_lcddata; s_page_setup(23 to 31) <= page_block(23 to 31); 
          when "0111" => s_page_setup(23) <=s_lcddata; s_page_setup(24 to 31) <= page_block(24 to 31); 
          when "1000" => s_page_setup(24) <=s_lcddata; s_page_setup(25 to 31) <= page_block(25 to 31); 
          when "1001" => s_page_setup(25) <=s_lcddata; s_page_setup(26 to 31) <= page_block(26 to 31); 
          when "1010" => s_page_setup(26) <=s_lcddata; s_page_setup(27 to 31) <= page_block(27 to 31); 
          when "1011" => s_page_setup(27) <=s_lcddata; s_page_setup(28 to 31) <= page_block(28 to 31); 
          when "1100" => s_page_setup(28) <=s_lcddata; s_page_setup(29 to 31) <= page_block(29 to 31); 
          when "1101" => s_page_setup(29) <=s_lcddata; s_page_setup(30 to 31) <= page_block(30 to 31); 
          when "1110" => s_page_setup(30) <=s_lcddata; s_page_setup(31)       <= page_block(31)      ;
      --    when "1111" => s_page_setup(31) <=s_lcddata;
          when others => NULL;
          end case; 
        elsif(s_input_word(0) ="0000") then
          s_page_setup <= page_setup;
        end if;  
      end if;
    else 
      s_page_setup <= page_setup;
    end if;
  end process;
  
  process(pr_state,s_lcddata,s_input_word(0),keyboard_i) 
  begin      
    if(pr_state=try or pr_state = pre_setup) then
      if rising_edge(clk_100hz_i) then
        if(keyboard_i='1') then
          case s_input_word(0) is
          when "0000" => s_page_input(16) <=s_lcddata;  s_page_input(17 to 31) <= page_block(17 to 31); 
          when "0001" => s_page_input(17) <=s_lcddata;  s_page_input(18 to 31) <= page_block(18 to 31); 
          when "0010" => s_page_input(18) <=s_lcddata;  s_page_input(19 to 31) <= page_block(19 to 31); 
          when "0011" => s_page_input(19) <=s_lcddata;  s_page_input(20 to 31) <= page_block(20 to 31); 
          when "0100" => s_page_input(20) <=s_lcddata;  s_page_input(21 to 31) <= page_block(21 to 31); 
          when "0101" => s_page_input(21) <=s_lcddata;  s_page_input(22 to 31) <= page_block(22 to 31); 
          when "0110" => s_page_input(22) <=s_lcddata;  s_page_input(23 to 31) <= page_block(23 to 31); 
          when "0111" => s_page_input(23) <=s_lcddata;  s_page_input(24 to 31) <= page_block(24 to 31); 
          when "1000" => s_page_input(24) <=s_lcddata;  s_page_input(25 to 31) <= page_block(25 to 31); 
          when "1001" => s_page_input(25) <=s_lcddata;  s_page_input(26 to 31) <= page_block(26 to 31); 
          when "1010" => s_page_input(26) <=s_lcddata;  s_page_input(27 to 31) <= page_block(27 to 31); 
          when "1011" => s_page_input(27) <=s_lcddata;  s_page_input(28 to 31) <= page_block(28 to 31); 
          when "1100" => s_page_input(28) <=s_lcddata;  s_page_input(29 to 31) <= page_block(29 to 31); 
          when "1101" => s_page_input(29) <=s_lcddata;  s_page_input(30 to 31) <= page_block(30 to 31); 
          when "1110" => s_page_input(30) <=s_lcddata;  s_page_input(31)       <= page_block(31)      ;
     --     when "1111" => s_page_input(31) <=s_lcddata;
          when others => NULL;
          end case; 
        elsif(s_input_word(0) = "0000") then
          s_page_input <= page_input;
        end if;
      end if;
    else 
      s_page_input <= page_input;
    end if;
  end process;  

end rtl;

