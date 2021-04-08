----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 02:41:22 PM
-- Design Name: 
-- Module Name: Main_Control - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main_Control is
    Port ( instr : in STD_LOGIC_VECTOR (15 downto 0);
           reg_dst : out STD_LOGIC;
           ext_op : out STD_LOGIC;
           alu_src : out STD_LOGIC;
           branch : out STD_LOGIC;
           jmp : out STD_LOGIC;
           alu_op : out STD_LOGIC_VECTOR (2 downto 0);
           mem_write : out STD_LOGIC;
           mem_to_reg : out STD_LOGIC;
           reg_write : out STD_LOGIC);
end Main_Control;

architecture Behavioral of Main_Control is

begin

process(instr)
begin
reg_dst<='0';
ext_op<='0';
alu_src<='0';
branch<='0';
jmp<='0';
mem_write<='0';
mem_to_reg<='0';
reg_write<='0';
alu_op<="000";

case instr(15 downto 13) is

when "000"=>--R type
reg_dst<='1';
reg_write<='1';
alu_op<="000";
when "001"=>--addi
reg_write<='1';
alu_src<='1';
ext_op<='1';
alu_op<="001";
when "010"=>--andi
reg_write<='1';
alu_src<='1';
alu_op<="011";--and
when "011"=>--ori
reg_write<='1';
alu_src<='1';
alu_op<="100";--si
when "100"=>--lw
reg_write<='1';
alu_src<='1';
ext_op<='1';
mem_to_reg<='1';
alu_op<="001";--adunare
when "101"=>----sw
alu_src<='1';
ext_op<='1';
mem_write<='1';
alu_op<="001";--adunare
when "110"=>--beq
ext_op<='1';
branch<='1';
alu_op<="010";--scadere
when "111"=>--jmp
jmp<='1';
alu_op<="001";
end case;
end process;


end Behavioral;
