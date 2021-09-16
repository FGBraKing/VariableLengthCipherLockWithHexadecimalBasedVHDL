----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:57:45 12/29/2017 
-- Design Name: 
-- Module Name:    compare_password - rtl 
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

entity compare_password is
    Port ( input_paaaword : in  password_type;
           real_password : in  password_type;
           eq : out  STD_LOGIC;
           ueq : out  STD_LOGIC);
end compare_password;

architecture rtl of compare_password is
  signal len_in : integer range 0 to 28:=8;
  signal len_on : integer range 0 to 28:=8;
begin
 process(input_paaaword(0))
 begin
  case input_paaaword(0) is
    when "0000" => len_in <= 0 ;
    when "0001" => len_in <= 1 ;
    when "0010" => len_in <= 2 ;
    when "0011" => len_in <= 3 ;
    when "0100" => len_in <= 4 ;
    when "0101" => len_in <= 5 ;
    when "0110" => len_in <= 6 ;
    when "0111" => len_in <= 7 ;
    when "1000" => len_in <= 8 ;
    when "1001" => len_in <= 9 ;
    when "1010" => len_in <= 10;
    when "1011" => len_in <= 11;
    when "1100" => len_in <= 12;
    when "1101" => len_in <= 13;
    when "1110" => len_in <= 14;
    when "1111" => len_in <= 15;
    when others => len_in <= 8 ;
  end case;    
 end process;
--
  process(real_password(0))
  begin
  case real_password(0) is
    when "0000" => len_on <= 0  ;
    when "0001" => len_on <= 1  ;
    when "0010" => len_on <= 2  ;
    when "0011" => len_on <= 3  ;
    when "0100" => len_on <= 4  ;
    when "0101" => len_on <= 5  ;
    when "0110" => len_on <= 6  ;
    when "0111" => len_on <= 7  ;
    when "1000" => len_on <= 8  ;
    when "1001" => len_on <= 9  ;
    when "1010" => len_on <= 10 ;
    when "1011" => len_on <= 11 ;
    when "1100" => len_on <= 12 ;
    when "1101" => len_on <= 13 ;
    when "1110" => len_on <= 14 ;
    when "1111" => len_on <= 15 ;
    when others => len_on <= 8  ;
  end case; 
  end process;
  
--  eq <='1';
--  ueq <='0';
process(len_in,len_on,input_paaaword,real_password)  
begin
  if(len_on = 0) then
    eq <='1';
    ueq <='0';
  elsif(len_in = len_on) then
    case len_in is
    when 1 => 
    if(input_paaaword(0 to 1) =real_password(0 to 1)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;
    when 2 => 
    if(input_paaaword(0 to 2) =real_password(0 to 2)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;    
    when 3 => 
    if(input_paaaword(0 to 3) =real_password(0 to 3)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;    
     when 4 => 
    if(input_paaaword(0 to 4) =real_password(0 to 4)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;   
     when 5 => 
    if(input_paaaword(0 to 5) =real_password(0 to 5)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;   
     when 6 => 
    if(input_paaaword(0 to 6) =real_password(0 to 6)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;   
     when 7 => 
    if(input_paaaword(0 to 7) =real_password(0 to 7)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;   
    when 8 => 
    if(input_paaaword(0 to 8) =real_password(0 to 8)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;    
     when 9 => 
    if(input_paaaword(0 to 9) =real_password(0 to 9)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;   
    when 10 => 
    if(input_paaaword(0 to 10) =real_password(0 to 10)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;    
     when 11 => 
    if(input_paaaword(0 to 11) =real_password(0 to 11)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;
    when 12 => 
    if(input_paaaword(0 to 12) =real_password(0 to 12)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;
    when 13 => 
    if(input_paaaword(0 to 13) =real_password(0 to 13)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;
    when 14 => 
    if(input_paaaword(0 to 14) =real_password(0 to 14)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;
    when 15 => 
    if(input_paaaword(0 to 15) =real_password(0 to 15)) then
      eq <='1';
      ueq <='0';
    else 
      eq <='0';
      ueq <='1';
    end if;
    when others => 
      eq <='0';
      ueq <='1';
    end case;  
  else
      eq <='0';
      ueq <='1';
  end if;
end process;
end rtl;

