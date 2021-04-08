----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 01:48:31 PM
-- Design Name: 
-- Module Name: Instruction_Decoder - Behavioral
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

entity Instruction_Decoder is
    Port ( reg_write : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           reg_dest : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ext_op : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wa:in STD_LOGIC_VECTOR(2 downto 0);
           rdata1 : out STD_LOGIC_VECTOR (15 downto 0);
           rdata2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           funct : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           rd:out STD_LOGIC_VECTOR(2 downto 0);
           rt:out STD_LOGIC_VECTOR(2 downto 0));
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is
type registru is array (0 to 7) of std_logic_vector(15 downto 0);
signal ref: registru ;
signal raddr1:std_logic_vector(2 downto 0);
signal raddr2:std_logic_vector(2 downto 0);

begin
raddr2<=instr(9 downto 7);
raddr1<=instr(12 downto 10);

process(clk)
begin
if falling_edge(clk) then
if en='1' and reg_write='1' then
ref(conv_integer(wa))<=wd;
end if;
end if;
end process;

process(ext_op,instr)
begin
if ext_op='1' and instr(6)='1' then
    ext_imm<="111111111"&instr(6 downto 0);
    else 
    ext_imm<="000000000"&instr(6 downto 0);
  end if;
  end process;

rdata1<=ref(conv_integer(raddr1));
rdata2<=ref(conv_integer(raddr2));
funct<=instr(2 downto 0);
sa<=instr(3);

rd<=instr(6 downto 4);
rt<=instr(9 downto 7);
end Behavioral;
