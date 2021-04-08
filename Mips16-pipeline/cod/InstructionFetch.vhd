-------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2020 14:38:05
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
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

entity InstructionFetch is
    Port ( clk : in STD_LOGIC;
           jmp : in STD_LOGIC;
           jmp_addr : in STD_LOGIC_VECTOR (15 downto 0);
           pcsrc : in STD_LOGIC;
           branch_addr : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           rst:in STD_LOGIC;
           next_instr : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is
type memorie is array(0 to 26) of std_logic_vector(15 downto 0);
signal ROM : memorie  := ( 0=>B"011_000_001_0000111", --(6087)ori $1,$0,7 initializaza R1 cu7
1=>B"001_000_010_0010000", --(2110) addi $2,$0,16 initializa R2 cu 16
2=>B"011_000_110_0000100",--(6304)ori $6,$0,4 se pune val 4 in R6
3=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
4=>B"000_001_010_011_0_101", --(0535)xor$3,$1,$2 xor intre R1 si R2 rezultat in  R3
5=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
6=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
7=>B"000_011_010_100_0_001", --(0D41)sub $4,$3,$2 R3-R2 rezultat in R4
8=>B"000_010_110_010_0_000",--(0B20)add $2,$2,$6 se adauga R6 la R2 
9=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
10=>B"101_001_100_0000000",--(A600)sw $4,0($1) stocheaza in memorie la adresa 7 val din R4
11=>B"001_010_010_0000001",--(2901)addi$2,$2,1 se adauga 1 la R2
12=>B"000_000_001_001_1_111",--(009F)srl $1,$1,1 deplasare la dreapta cu 1 bit al R1
13=>B"100_100_101_0000000",--(9280)lw $5,0($4) se incarca din memorie de la adresa 7 in R5
14=>B"110_010_011_0000100",--(C984)beq $2,$3,1 daca R2=R3 se sare la instructiunea 19
15=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
16=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
17=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
18=>B"111_0000000001011",--(E00D)j 11 salt la instr 11
19=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
20=>B"100_001_110_0000111",--(8707)lw $6,7($1) se incarca din memorie de la adresa 7 in R6
21=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
22=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
23=>B"000_110_101_100_0_001",--(1AC1)sub $4,$6,$5 in R4 va fi R6-R5
24=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
25=>B"001_000_000_0000000", --(2000) addi $0,$0,0 NoOp
26=>B"101_000_100_0000110"--(A206)sw $4,6($0) se stocheaza in memorie la adresa 6 valoarea din R4
);

signal temp : std_logic_vector(15 downto 0) :=x"0000";
signal out_mux2 :std_logic_vector(15 downto 0) :=x"0000";
signal out_mux1 : std_logic_vector(15 downto 0):=x"0000";

begin

process(clk)
begin
   if rising_edge(clk) then 
        if rst='1' then
            temp<=x"0000";
            elsif en='1' then
             temp<=out_mux2;
         end if;
         end if;
        
end process;


next_instr<=temp+1;
instr<= ROM(conv_integer(temp(4 downto 0)));


process(pcsrc,temp,branch_addr) 
begin
if pcsrc='0' then
     out_mux1<=temp+x"0001";
 else
     out_mux1<=branch_addr;
end if;
end process;

process(jmp,jmp_addr,out_mux1)
begin
if jmp='1' then
     out_mux2<=jmp_addr;
 else
      out_mux2<=out_mux1;
 end if;
end process;

end Behavioral;