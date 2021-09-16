----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:31:53 12/24/2017 
-- Design Name: 
-- Module Name:    clk_div - rtl 
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

entity clk_div is
    Port ( clk_50mhz_i : in  STD_LOGIC;
           clk_2hz_o : out  STD_LOGIC;
           clk_50hz_o : out  STD_LOGIC;
           clk_100hz_o : out  STD_LOGIC;
           clk_200hz_o : out  STD_LOGIC;
           clk_1mhz_o : out  STD_LOGIC);
end clk_div;

architecture rtl of clk_div is

signal s_cnt_2hz        : integer range 0 to 24_999_999 :=0 ;
signal s_cnt_50hz       : integer range 0 to 999999 :=0 ;
signal s_cnt_100hz      : integer range 0 to 499999 :=0 ;
signal s_cnt_200hz      : integer range 0 to 249999 :=0 ;
signal s_cnt_1mhz       : integer range 0 to 49     :=0 ;

signal s_clk_2hz        : std_logic :='0';
signal s_clk_50hz       : std_logic :='0';
signal s_clk_100hz      : std_logic :='0';
signal s_clk_200hz      : std_logic :='0';
signal s_clk_1mhz       : std_logic :='0';

begin

clk_2hz_o     <= s_clk_2hz;
clk_50hz_o    <= s_clk_50hz;
clk_100hz_o   <= s_clk_100hz;
clk_200hz_o   <= s_clk_200hz;
clk_1mhz_o    <= s_clk_1mhz;


process(clk_50mhz_i)
begin
  if rising_edge(clk_50mhz_i) then
    if(s_cnt_2hz >= 24_999999) then
      s_cnt_2hz <=0;
      s_clk_2hz <= '0';
    elsif(s_cnt_2hz = 12_499_999)  then  
      s_clk_2hz <='1';
      s_cnt_2hz <=s_cnt_2hz+1;
    else
      s_cnt_2hz <=s_cnt_2hz+1;
    end if;
  end if; 
end process;

process(clk_50mhz_i)
begin
  if rising_edge(clk_50mhz_i) then
    if(s_cnt_50hz >= 999999) then
      s_cnt_50hz <=0;
      s_clk_50hz <= '0';
    elsif(s_cnt_50hz = 499999)  then  
      s_clk_50hz <='1';
      s_cnt_50hz <=s_cnt_50hz+1;
    else
      s_cnt_50hz <=s_cnt_50hz+1;
    end if;
  end if; 
end process;

process(clk_50mhz_i)
begin
  if rising_edge(clk_50mhz_i) then
    if(s_cnt_100hz >= 499999) then
      s_cnt_100hz <=0;
      s_clk_100hz <= '0';
    elsif(s_cnt_100hz = 249999)  then  
      s_clk_100hz <='1';
      s_cnt_100hz <=s_cnt_100hz+1;
    else
      s_cnt_100hz <=s_cnt_100hz+1;
    end if;
  end if; 
end process;

process(clk_50mhz_i)
begin
  if rising_edge(clk_50mhz_i) then
    if(s_cnt_200hz >= 249999) then
      s_cnt_200hz <=0;
      s_clk_200hz <= '0';
    elsif(s_cnt_200hz = 124999)  then  
      s_clk_200hz <='1';
      s_cnt_200hz <=s_cnt_200hz+1;
    else
      s_cnt_200hz <=s_cnt_200hz+1;
    end if;
  end if; 
end process;

process(clk_50mhz_i)
begin
  if rising_edge(clk_50mhz_i) then
    if(s_cnt_1mhz >= 49) then
      s_cnt_1mhz <=0;
      s_clk_1mhz <= '0';
    elsif(s_cnt_1mhz = 24)  then
      s_clk_1mhz <='1';
      s_cnt_1mhz <=s_cnt_1mhz+1;
    else
      s_cnt_1mhz <=s_cnt_1mhz+1;
    end if;
  end if; 
end process;

end rtl;

