----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2020 05:32:19 PM
-- Design Name: 
-- Module Name: EX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           alu_src : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           funct : in STD_LOGIC_VECTOR (2 downto 0);
           alu_op : in STD_LOGIC_VECTOR (2 downto 0);
           next_instr : in STD_LOGIC_VECTOR (15 downto 0);
           rd:in STD_LOGIC_VECTOR(2 downto 0);
           rt:in STD_LOGIC_VECTOR (2 downto 0);
           reg_dest:in STD_LOGIC;
           zero : out STD_LOGIC;
           alu_res : out STD_LOGIC_VECTOR (15 downto 0);
           branch_address : out STD_LOGIC_VECTOR (15 downto 0);
           rWa:out STD_LOGIC_VECTOR(2 downto 0));
end EX;

architecture Behavioral of EX is
signal alu_operand:std_logic_vector(15 downto 0 );
signal alu_ctrl:std_logic_vector(2 downto 0);
signal temp:std_logic_vector(15 downto 0 );
begin


 rWa <= rd when (reg_dest = '1') else  rt;
 
process(rd2,ext_imm,alu_src)
begin
if alu_src='0' then
alu_operand<=rd2;
else alu_operand<=ext_imm;
end if;
end process;

process(alu_op,funct)
begin
case alu_op is
--tip r
when "000" =>
    case funct is
    
    when "000"  => alu_ctrl<="001";--adunare
    when "001" => alu_ctrl<="010";--scadere
    when "010" => alu_ctrl<="110"; --shift aritmetic stanga
    when "011" => alu_ctrl<="011"; --and
    when "100"=> alu_ctrl<="100"; --or
    when "101"=> alu_ctrl<="111"; --xor
    when "110"=> alu_ctrl<="000"; --shift logic stanga
    when "111"=> alu_ctrl<="101"; --shift logic dreapta
end case;
   --tip i , tip j
    when "001" => alu_ctrl<="001";--adunare
    when "010" => alu_ctrl<="010"; --scadere
    when "011" => alu_ctrl<="011"; --and
    when "100"=> alu_ctrl<="100"; --or
    when others=> alu_ctrl<=(others=>'X');
end case;
end process;

process(alu_ctrl,rd1,alu_operand)
begin
case alu_ctrl is
when "000"=> if sa='1' then
    temp<=alu_operand(14 downto 0)& '0';
    else temp<=alu_operand;
    end if;--sll
when "001"=> temp<=rd1+alu_operand;--adunare
when "010"=> temp<=rd1-alu_operand;--sacadere
when "011" =>temp<=rd1 and alu_operand; --and
when "100" =>temp<= rd1 or alu_operand;--or
when "101" =>if sa='1' then
   temp<='0'&alu_operand(15 downto 1);
    else temp<=alu_operand;
    end if;--srl
when "110"=> if sa='1' then
   temp<=alu_operand(15)&alu_operand(15 downto 1);
    else temp<=alu_operand;
    end if;--sra
when "111"=> temp<=rd1 xor alu_operand;--xor
end case;

end process;

process(temp)
begin
if temp=x"0000" then
zero<='1';
else zero<='0';
end if;
end process;

alu_res<=temp;
branch_address<=ext_imm+next_instr;

end Behavioral;
