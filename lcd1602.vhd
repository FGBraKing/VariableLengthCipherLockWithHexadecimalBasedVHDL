library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all;
---------------------------------------ENTITY DECLARATION-------------------------------------------------
entity lcd1602 is   
  generic(
    LCD_COM     : std_logic := '0';
    LCD_DATA    : std_logic := '1';
    LCD_READ    : std_logic := '1';
    LCD_WRITE   : std_logic := '0';
    LCD_LOW     : std_logic := '0';
    LCD_HIGH    : std_logic := '1'
    );
    
  port(
    clk_1mhz_i  : in  std_logic;   
    rst_n_i     : in  std_logic;  
    data_i      : in  display_array;
    lcd_rs_o    : out std_logic; 
    lcd_wr_o    : out std_logic; 
    lcd_en_o    : out std_logic; 
    lcd_data_o  : out std_logic_vector(7 downto 0)
    );
end lcd1602;

----------------------------------------------------------------------------------------------------------

---------------------------------------ARCHITECTURE STRUCTURAL--------------------------------------------
architecture rtl of lcd1602 is
  type state is (wr_com_38h, 
                 wr_com_08h,     wr_com_01h,     wr_com_06h,     wr_com_0ch,
                 set_ddram,      wr_data,				 state_reset);
            
  signal pr_state, nx_state: state;
  
  signal s_cnt      : integer range 0 to 15000  := 0;   --以us为单位，计数到15000代表15ms   
  signal s_max_cnt  : integer range 0 to 15000  := 0;   --计数的最大值
  
  signal s_addr_cnt : integer range 0 to 31     := 0;
  
  signal s_lcd_ddram_addr : std_logic_vector(7 downto 0) := "10000000";
  signal s_lcd_ddram_data : std_logic_vector(7 downto 0) := "00100000";
  signal s_start_addr_cnt : std_logic := LCD_LOW;
  
begin
----------------------------------------------------------------------------------------------------------
--时钟分频模块映射，输入时钟为clk_1mhz_i，输出时钟为clk_1mhz_i
----------------------------------------------------------------------------------------------------------
    
  fsm_lowersection:process(clk_1mhz_i, rst_n_i)
  begin
  --default values  
  --pr_state                <= state_reset;  
    if (rst_n_i = '0')then
	   pr_state <= state_reset;
    elsif rising_edge(clk_1mhz_i)then
	   pr_state <= nx_state;
	 end if;
  end process;
  
  fsm_uppersection:process(pr_state, s_cnt, s_lcd_ddram_data, s_lcd_ddram_addr)
  begin
    --default values  
    nx_state          <= state_reset;
    lcd_wr_o          <= LCD_WRITE;                                                             --wr rs en data
    lcd_rs_o          <= LCD_DATA;
    lcd_data_o        <= "11111111";
    lcd_en_o          <= LCD_LOW;
    s_max_cnt         <= 0;
    s_start_addr_cnt  <= LCD_LOW;

    case pr_state is
      when state_reset =>
        nx_state      <= wr_com_38h;
      when wr_com_38h =>
        s_max_cnt     <= 15000;             --等待15000us
        if    (s_cnt < s_max_cnt - 3) then
          nx_state    <= wr_com_38h;
        elsif (s_cnt = s_max_cnt - 3) then  --T0
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00111000";        --38h		  
          nx_state    <= wr_com_38h;
        elsif (s_cnt = s_max_cnt - 2) then  --T1
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00111000";        --38h	
          lcd_en_o    <= LCD_HIGH;
          nx_state    <= wr_com_38h;			 
        elsif (s_cnt = s_max_cnt - 1) then  --T2
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00111000";        --38h	
          nx_state    <= wr_com_38h;
        elsif (s_cnt >= s_max_cnt) then
          nx_state    <= wr_com_08h;
        end if;
      when wr_com_08h =>
        s_max_cnt     <= 40;                --等待40us
        if    (s_cnt < s_max_cnt - 3) then
          nx_state    <= wr_com_08h;
        elsif (s_cnt = s_max_cnt - 3) then  --T0
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00001000";        --08h		  
          nx_state    <= wr_com_08h;
        elsif (s_cnt = s_max_cnt - 2) then  --T1
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00001000";        --08h	
          lcd_en_o    <= LCD_HIGH;
          nx_state    <= wr_com_08h;			 
        elsif (s_cnt = s_max_cnt - 1) then  --T2
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00001000";        --08h	
          nx_state    <= wr_com_08h;
        elsif (s_cnt >= s_max_cnt) then
          nx_state    <= wr_com_01h;
        end if;
      when wr_com_01h =>
        s_max_cnt     <= 40;                --等待40us
        if    (s_cnt < s_max_cnt - 3) then
          nx_state    <= wr_com_01h;
        elsif (s_cnt  = s_max_cnt - 3) then --T0
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00000001";        --01h		  
          nx_state    <= wr_com_01h;
        elsif (s_cnt = s_max_cnt - 2) then  --T1
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00000001";        --01h
          lcd_en_o    <= LCD_HIGH;
          nx_state    <= wr_com_01h;			 
        elsif (s_cnt = s_max_cnt - 1) then  --T2
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00000001";        --01h
          nx_state    <= wr_com_01h;
        elsif (s_cnt >= s_max_cnt) then
          nx_state    <= wr_com_06h;
        end if;		  	
      when wr_com_06h =>
        s_max_cnt     <= 1640;              --等待1.64ms
        if    (s_cnt < s_max_cnt - 3) then
          nx_state    <= wr_com_06h;
        elsif (s_cnt = s_max_cnt - 3) then  --T0
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00000110";        --06h		  
          nx_state    <= wr_com_06h;
        elsif (s_cnt = s_max_cnt - 2) then  --T1
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00000110";        --06h		
          lcd_en_o    <= LCD_HIGH;
          nx_state    <= wr_com_06h;			 
        elsif (s_cnt = s_max_cnt - 1) then  --T2
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00000110";        --06h		
          nx_state    <= wr_com_06h;
        elsif (s_cnt >= s_max_cnt) then
          nx_state    <= wr_com_0Ch;
        end if;		  	
      when wr_com_0Ch =>
        s_max_cnt     <= 40;                --等待40us
        if    (s_cnt < s_max_cnt - 3) then
          nx_state    <= wr_com_0Ch;
        elsif (s_cnt = s_max_cnt - 3) then  --T0
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00001100";        --0Ch		  
          nx_state    <= wr_com_0Ch;
        elsif (s_cnt = s_max_cnt - 2) then  --T1
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00001100";        --0Ch	
          lcd_en_o    <= LCD_HIGH;
          nx_state    <= wr_com_0Ch;			 
        elsif (s_cnt = s_max_cnt - 1) then  --T2
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= "00001100";        --0Ch	
          nx_state    <= wr_com_0Ch;
        elsif (s_cnt >= s_max_cnt) then
          nx_state    <= set_ddram;
        end if;
      when set_ddram =>
        s_max_cnt     <= 40;                --等待40us
        if    (s_cnt < s_max_cnt - 3) then
          nx_state    <= set_ddram;
        elsif (s_cnt = s_max_cnt - 3) then  --T0
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= s_lcd_ddram_addr;
          nx_state    <= set_ddram;
        elsif (s_cnt = s_max_cnt - 2) then  --T1
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= s_lcd_ddram_addr;
          lcd_en_o    <= LCD_HIGH;
          nx_state    <= set_ddram;			 
        elsif (s_cnt = s_max_cnt - 1) then  --T2
          lcd_rs_o    <= LCD_COM;
          lcd_data_o  <= s_lcd_ddram_addr;
          nx_state    <= set_ddram;
        elsif (s_cnt >= s_max_cnt) then
          nx_state    <= wr_data;
        end if;
      when wr_data =>
        s_max_cnt     <= 40;                --等待40us
        if    (s_cnt < s_max_cnt - 3) then
          nx_state    <= wr_data;
          lcd_rs_o    <= LCD_DATA;
        elsif (s_cnt = s_max_cnt - 3) then  --T0
          lcd_rs_o    <= LCD_DATA;
          lcd_data_o  <= s_lcd_ddram_data;		  
          nx_state    <= wr_data;
        elsif (s_cnt = s_max_cnt - 2) then  --T1
          lcd_rs_o    <= LCD_DATA;
          lcd_data_o  <= s_lcd_ddram_data;	
          lcd_rs_o    <= LCD_DATA;
          lcd_en_o    <= LCD_HIGH;
          nx_state    <= wr_data;			 
        elsif (s_cnt = s_max_cnt - 1) then  --T2
          lcd_rs_o    <= LCD_DATA;
          lcd_data_o  <= s_lcd_ddram_data;	
          lcd_rs_o    <= LCD_DATA;
          nx_state    <= wr_data;
        elsif (s_cnt >= s_max_cnt) then
          nx_state    <= set_ddram;
          s_start_addr_cnt  <= LCD_HIGH;    --一定要把这个问题搞清楚，不要留死角，仿真与综合的结果不一样，为什么呢？
        end if;	  
      end case;
  end process;	
  
  cnt_process:process(rst_n_i, clk_1mhz_i, s_cnt)
  begin
    if (rst_n_i = '0') then
      s_cnt <= 0;
    elsif rising_edge(clk_1mhz_i) then 
      if (s_cnt >= s_max_cnt) then
        s_cnt <= 0;
      else
        s_cnt <= s_cnt + 1;
      end if;
    end if;
  end process;

  s_start_addr_cnt_process:process(rst_n_i, clk_1mhz_i, s_start_addr_cnt, s_addr_cnt)
  begin
    if (rst_n_i = '0') then
      s_addr_cnt <= 0;
    elsif rising_edge(clk_1mhz_i) then
      if (s_start_addr_cnt = '1') then
        if (s_addr_cnt >= 32) then
          s_addr_cnt <= 0;
        else
          s_addr_cnt <= s_addr_cnt + 1;
        end if;
      end if;
    end if;
  end process;
	 
  decoder_ddram_addr_proc:process(s_addr_cnt)
  begin
    if (s_addr_cnt >= 0 and s_addr_cnt <= 15) then
      s_lcd_ddram_addr  <= "10000000" + conv_std_logic_vector(s_addr_cnt, 8);       --10h
    elsif (s_addr_cnt >= 16 and s_addr_cnt <= 31) then
      s_lcd_ddram_addr  <= "10110000" + conv_std_logic_vector(s_addr_cnt, 8);       --b0h
    end if;
  end process;		

  decoder_ddram_data_proc:process (s_addr_cnt,data_i)
  begin
    case s_addr_cnt is
      when 0      => s_lcd_ddram_data <= data_i(0);
      when 1      => s_lcd_ddram_data <= data_i(1);
      when 2      => s_lcd_ddram_data <= data_i(2);
      when 3      => s_lcd_ddram_data <= data_i(3);
      when 4      => s_lcd_ddram_data <= data_i(4);
      when 5      => s_lcd_ddram_data <= data_i(5);
      when 6      => s_lcd_ddram_data <= data_i(6);
      when 7      => s_lcd_ddram_data <= data_i(7);
      when 8      => s_lcd_ddram_data <= data_i(8);
      when 9      => s_lcd_ddram_data <= data_i(9);
      when 10     => s_lcd_ddram_data <= data_i(10);
      when 11     => s_lcd_ddram_data <= data_i(11);
      when 12     => s_lcd_ddram_data <= data_i(12);
      when 13     => s_lcd_ddram_data <= data_i(13);
      when 14     => s_lcd_ddram_data <= data_i(14);
      when 15     => s_lcd_ddram_data <= data_i(15);
      when 16     => s_lcd_ddram_data <= data_i(16);
      when 17     => s_lcd_ddram_data <= data_i(17);
      when 18     => s_lcd_ddram_data <= data_i(18);
      when 19     => s_lcd_ddram_data <= data_i(19);
      when 20     => s_lcd_ddram_data <= data_i(20);
      when 21     => s_lcd_ddram_data <= data_i(21);
      when 22     => s_lcd_ddram_data <= data_i(22);
      when 23     => s_lcd_ddram_data <= data_i(23);
      when 24     => s_lcd_ddram_data <= data_i(24);
      when 25     => s_lcd_ddram_data <= data_i(25);
      when 26     => s_lcd_ddram_data <= data_i(26);
      when 27     => s_lcd_ddram_data <= data_i(27);
      when 28     => s_lcd_ddram_data <= data_i(28);
      when 29     => s_lcd_ddram_data <= data_i(29);
      when 30     => s_lcd_ddram_data <= data_i(30);
      when 31     => s_lcd_ddram_data <= data_i(31);
      when others => s_lcd_ddram_data <= conv_std_logic_vector(char_to_integer (' ') ,8);
    end case;
  end process;  

end rtl;