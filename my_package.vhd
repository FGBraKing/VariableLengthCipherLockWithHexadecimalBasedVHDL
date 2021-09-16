--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package my_package is

  type password_type is array(0 to 15) of std_logic_vector(3 downto 0); --第一个向量储存长度

  constant default_password : password_type :=(x"8", x"1",x"0",x"2",x"5", x"0",x"8",x"1",x"4", x"0",x"8",x"1",x"4", x"0",x"8",x"1");
  constant default_input    : password_type :=(x"0", x"1",x"0",x"2",x"5", x"0",x"8",x"1",x"4", x"0",x"8",x"1",x"4", x"0",x"8",x"1");
--  constant length_default_password :integer :=10;

  --lcd1602输出数据类型定义
  type display_array is array(0 to 31) of std_logic_vector(7 downto 0);   
--  type row_display   is array(0 to 15) of std_logic_vector(7 downto 0); 
--  
--  constant row_blank : row_display :=(
--    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
--    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20"
--    );   
  
  constant page_nomal : display_array :=(
    x"20",x"20",x"20",x"20", x"57",x"65",x"6c",x"63",
    x"6f",x"6d",x"65",x"21", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"46",
    x"47",x"20",x"20",x"20", x"20",x"20",x"20",x"20"
    );
    
  constant page_error : display_array :=(
    x"20",x"20",x"20",x"20", x"20",x"45",x"72",x"72",
    x"6f",x"72",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20"
    );
     
  constant page_illegal : display_array :=(
    x"20",x"20",x"20",x"20", x"69",x"6c",x"6c",x"65",
    x"67",x"61",x"6c",x"21", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20"
    );
    
  constant page_success : display_array :=(
    x"20",x"20",x"20",x"20", x"53",x"75",x"63",x"63",
    x"65",x"73",x"73",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20"
    ); 
    
  constant page_input : display_array :=(
    x"20",x"50",x"61",x"73", x"73",x"77",x"6f",x"72",
    x"64",x"20",x"69",x"6e", x"70",x"75",x"74",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20"
    ); 

  constant page_setup : display_array :=(
    x"20",x"50",x"61",x"73", x"73",x"77",x"6f",x"72",
    x"64",x"20",x"73",x"65", x"74",x"75",x"70",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20"
    ); 
    
  constant page_block : display_array :=(
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20",
    x"20",x"20",x"20",x"20", x"20",x"20",x"20",x"20"
    );     
   
  --输出控制
  component lcd1602 is
      port(
    clk_1mhz_i : in  std_logic;   
    rst_n_i     : in  std_logic;  
    data_i      : in  display_array;
    lcd_rs_o    : out std_logic; 
    lcd_wr_o    : out std_logic; 
    lcd_en_o    : out std_logic; 
    lcd_data_o  : out std_logic_vector(7 downto 0)
    );
  end component;  
  
 --时钟生成 
	COMPONENT clk_div
	PORT(
		clk_50mhz_i : IN std_logic;          
		clk_2hz_o : OUT std_logic;
		clk_50hz_o : OUT std_logic;
		clk_100hz_o : OUT std_logic;
		clk_200hz_o : OUT std_logic;
		clk_1mhz_o : OUT std_logic
		);
	END COMPONENT;
 --按键信号处理 
	COMPONENT key_dealing
	PORT(
		clk_100hz_i : IN std_logic;
		clk_200hz_i : IN std_logic;
		mode_i : IN std_logic;
		enter_i : IN std_logic;
		rst_n_i : IN std_logic;
		pro_rst_n_i : IN std_logic;
		col_i : IN std_logic_vector(3 downto 0);          
		col_o : OUT std_logic_vector(3 downto 0);
		mode_o : OUT std_logic;
		enter_o : OUT std_logic;
		rst_o : OUT std_logic;
		pro_rst_o : OUT std_logic;
		key_matrix_o : OUT std_logic
		);
	END COMPONENT;
  
	COMPONENT keyboard_signal_pro
	PORT(
		clk_100hz_i : IN std_logic;
		clk_200hz_i : IN std_logic;
		keyboard_button_i : IN std_logic_vector(3 downto 0);          
		keyboard_but_all_o : OUT std_logic_vector(3 downto 0);
		keyboard_button_o : OUT std_logic
		);
	END COMPONENT;
  
	COMPONENT clr_jitter_reg
	PORT(
		clk_100hz_i : IN std_logic;
		button_i : IN std_logic;          
		button_o : OUT std_logic;
		button_n_o : OUT std_logic
		);
	END COMPONENT;
  --对矩阵键盘编码
  
	COMPONENT keyboard_code
	PORT(
		clk_50hz_i : IN std_logic;
    clk_100hz_i : in std_logic;
		en_i : IN std_logic;
		col_i : IN std_logic_vector(3 downto 0);          
		row_o : OUT std_logic_vector(3 downto 0);
		key_code_o : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
  
	COMPONENT row_scan
	PORT(
		clk_50hz_i : IN std_logic;          
		row_o : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;  
  
	COMPONENT row_delay
	PORT(
		clk_100hz_i : IN std_logic;
		row_i : IN std_logic_vector(3 downto 0);            --此模块不需要，因为使用100hz时钟对50hz时钟产生的列信号去抖，只延迟了5ms。考虑极限情况，假如时钟发生混乱，延迟的时间极限为0~10ms
		row_reg_o : OUT std_logic_vector(3 downto 0)        --而行信号的持续时间为20ms，无论如何延迟，总是可以检测到的
		);
	END COMPONENT;  
  
	COMPONENT combine
	PORT(
		row_i : IN std_logic_vector(3 downto 0);
		col_i : IN std_logic_vector(3 downto 0);          
		row_col_o : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
  
	COMPONENT decode_kboard
	PORT(
		row_col_i : IN std_logic_vector(7 downto 0);
		en_i : IN std_logic;          
		code_o : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
  
  --状态控制
 	COMPONENT led_water
	PORT(
		clk_2hz_i : IN std_logic;          
		led_o : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT; 
  
  COMPONENT bcd2lcddata
	PORT(
		led_i : IN std_logic_vector(3 downto 0);          
		lcddata : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT state_control
	PORT(
		clk_2hz_i : IN std_logic;
		clk_100hz_i : IN std_logic;
		mode_i : IN std_logic;
		enter_i : IN std_logic;
		rst_i : IN std_logic;
		pro_rst_i : IN std_logic;
		keyboard_i : IN std_logic;
		key_val_i : IN std_logic_vector(3 downto 0);          
		led_o : OUT std_logic_vector(3 downto 0);
		lcd_data_o : OUT display_array;
		beep_o : OUT std_logic
		);
	END COMPONENT;
  
  COMPONENT compare_password
	PORT(
		input_paaaword : IN password_type;
		real_password : IN password_type;          
		eq : OUT std_logic;
		ueq : OUT std_logic
		);
	END COMPONENT;



function char_to_integer (indata :character) return integer;
--function compare_password (signal input_paaaword :password_type;signal real_password :password_type ) return boolean;


end my_package;

package body my_package is

  function char_to_integer (indata :character) return integer is
  variable result : integer range 0 to 255;
  begin
    case indata is
      when ' ' =>		result := 32;
      when '!' =>		result := 33;
      when '"' =>		result := 34;
      when '#' =>		result := 35;
      when '$' =>		result := 36;
      when '%' =>		result := 37;
      when '&' =>		result := 38;
      when ''' =>		result := 39;
      when '(' =>		result := 40;
      when ')' =>		result := 41;
      when '*' =>		result := 42;
      when '+' =>		result := 43;
      when ',' =>		result := 44;
      when '-' =>		result := 45;
      when '.' =>		result := 46;
      when '/' =>		result := 47;
      when '0' =>		result := 48;
      when '1' =>		result := 49;
      when '2' =>		result := 50;
      when '3' =>		result := 51;
      when '4' =>		result := 52;
      when '5' =>		result := 53;
      when '6' =>		result := 54;
      when '7' =>		result := 55;
      when '8' =>		result := 56;
      when '9' =>		result := 57;
      when ':' =>		result := 58;
      when ';' =>		result := 59;
      when '<' =>		result := 60;
      when '=' =>		result := 61;
      when '>' =>		result := 62;
      when '?' =>		result := 63;
      when '@' =>		result := 64;
      when 'A' =>		result := 65;
      when 'B' =>		result := 66;
      when 'C' =>		result := 67;
      when 'D' =>		result := 68;
      when 'E' =>		result := 69;
      when 'F' =>		result := 70;
      when 'G' =>		result := 71;
      when 'H' =>		result := 72;
      when 'I' =>		result := 73;
      when 'J' =>		result := 74;
      when 'K' =>		result := 75;
      when 'L' =>		result := 76;
      when 'M' =>		result := 77;
      when 'N' =>		result := 78;
      when 'O' =>		result := 79;
      when 'P' =>		result := 80;
      when 'Q' =>		result := 81;
      when 'R' =>		result := 82;
      when 'S' =>		result := 83;
      when 'T' =>		result := 84;
      when 'U' =>		result := 85;
      when 'V' =>		result := 86;
      when 'W' =>		result := 87;
      when 'X' =>		result := 88;
      when 'Y' =>		result := 89;
      when 'Z' =>		result := 90;
      when '[' =>		result := 91;
      when '\' =>		result := 92;
      when ']' =>		result := 93;
      when '^' =>		result := 94;
      when '_' =>		result := 95;
      when '`' =>		result := 96;
      when 'a' =>		result := 97;
      when 'b' =>		result := 98;
      when 'c' =>		result := 99;
      when 'd' =>		result := 100;
      when 'e' =>		result := 101;
      when 'f' =>		result := 102;
      when 'g' =>		result := 103;
      when 'h' =>		result := 104;
      when 'i' =>		result := 105;
      when 'j' =>		result := 106;
      when 'k' =>		result := 107;
      when 'l' =>		result := 108;
      when 'm' =>		result := 109;
      when 'n' =>		result := 110;
      when 'o' =>		result := 111;
      when 'p' =>		result := 112;
      when 'q' =>		result := 113;
      when 'r' =>		result := 114;
      when 's' =>		result := 115;
      when 't' =>		result := 116;
      when 'u' =>		result := 117;
      when 'v' =>		result := 118;
      when 'w' =>		result := 119;
      when 'x' =>		result := 120;
      when 'y' =>		result := 121;
      when 'z' =>		result := 122;
      when '{' =>		result := 123;
      when '|' =>		result := 124;
      when '}' =>		result := 125;
      when '~' =>		result := 126;
      when	others => result :=32;
		end case;   
   return result;  
  end char_to_integer;

--function compare_password (signal input_paaaword :password_type; signal real_password :password_type ) return boolean is
--  variable len_in : integer range 0 to 32 := 8;
--  variable len_on : integer range 0 to 32 := 8;
--begin
--  case input_paaaword(0) is
--    when "0000" => len_in := 0 ;
--    when "0001" => len_in := 1 ;
--    when "0010" => len_in := 2 ;
--    when "0011" => len_in := 3 ;
--    when "0100" => len_in := 4 ;
--    when "0101" => len_in := 5 ;
--    when "0110" => len_in := 6 ;
--    when "0111" => len_in := 7 ;
--    when "1000" => len_in := 8 ;
--    when "1001" => len_in := 9 ;
--    when "1010" => len_in := 10;
--    when "1011" => len_in := 11;
--    when "1100" => len_in := 12;
--    when "1101" => len_in := 13;
--    when "1110" => len_in := 14;
--    when "1111" => len_in := 15;
--    when others => len_in := 8 ;
--  end case;    
--
--  case real_password(0) is
--    when "0000" => len_on := 0  ;
--    when "0001" => len_on := 1  ;
--    when "0010" => len_on := 2  ;
--    when "0011" => len_on := 3  ;
--    when "0100" => len_on := 4  ;
--    when "0101" => len_on := 5  ;
--    when "0110" => len_on := 6  ;
--    when "0111" => len_on := 7  ;
--    when "1000" => len_on := 8  ;
--    when "1001" => len_on := 9  ;
--    when "1010" => len_on := 10 ;
--    when "1011" => len_on := 11 ;
--    when "1100" => len_on := 12 ;
--    when "1101" => len_on := 13 ;
--    when "1110" => len_on := 14 ;
--    when "1111" => len_on := 15 ;
--    when others => len_on := 8  ;
--  end case; 
--  if(len_on >15 or len_in> 15) then
--    return false;
--  elsif(len_on=0) then
--    return true;
--  elsif(len_in = len_on) then
--    if(input_paaaword(0 to len_in)=real_password(0 to len_on)) then
--      return true;
--    else
--      return false;
--    end if;
--  else
--    return false;
--  end if;
--end compare_password;

end my_package;
