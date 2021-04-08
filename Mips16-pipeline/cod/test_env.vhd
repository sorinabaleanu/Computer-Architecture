----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2020 06:56:43 PM
-- Design Name: 
-- Module Name: ROM - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
component Monoimpuls is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component SSD is
    Port ( digit0: in STD_LOGIC_VECTOR(3 downto 0);
           digit1: in STD_LOGIC_VECTOR(3 downto 0);
           digit2: in STD_LOGIC_VECTOR(3 downto 0);
           digit3 : in STD_LOGIC_VECTOR(3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;
component InstructionFetch is
    Port ( clk : in STD_LOGIC;
           jmp : in STD_LOGIC;
           jmp_addr : in STD_LOGIC_VECTOR (15 downto 0);
           pcsrc : in STD_LOGIC;
           branch_addr : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           rst:in STD_LOGIC;
           next_instr : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component Instruction_Decoder is
    Port ( reg_write : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
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
end component;

component Main_Control is
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
end component;
component EX is
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
end component;

component MEM is
    Port ( mem_write : in STD_LOGIC;
           alu_res : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           mem_data : out STD_LOGIC_VECTOR (15 downto 0);
           alu_res_out : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal data:std_logic_vector(15 downto 0):=x"0000";
signal enb:std_logic;
signal rst:std_logic;
signal jmp_address: std_logic_vector(15 downto 0);
signal branch_address: std_logic_vector(15 downto 0);
signal instruction: std_logic_vector(15 downto 0);
signal next_instruction: std_logic_vector(15 downto 0);
signal reg_write:std_logic;
signal branch:std_logic;
 signal ext_op:std_logic;
signal alu_src:std_logic;
signal alu_op:std_logic_vector(2 downto 0);
 signal mem_write:std_logic;
signal mem_to_reg:std_logic;
signal reg_dest:std_logic;
signal write_data:std_logic_vector (15 downto 0);
signal rd1:std_logic_vector(15 downto 0 );
signal rd2:std_logic_vector(15 downto 0 );
signal ext_imm:std_logic_vector(15 downto 0);
signal funct:std_logic_vector(2 downto 0);
signal sa:std_logic;
signal jump:std_logic;
signal zero:std_logic;
signal alu_result:std_logic_vector(15 downto 0);
signal mem_data:std_logic_vector(15 downto 0);
signal alu_result_out:std_logic_vector(15 downto 0);
signal pc_src:std_logic;
signal rd:std_logic_vector(2 downto 0);
signal rt:std_logic_vector(2 downto 0);
signal rWa:std_logic_vector(2 downto 0);
--pipeline

signal reg_if_id: std_logic_vector(31 downto 0);
signal reg_id_ex: std_logic_vector(82 downto 0);
signal reg_ex_mem: std_logic_vector(55 downto 0);
signal reg_mem_wb: std_logic_vector(36 downto 0);


begin

M1: Monoimpuls port map(btn=>btn(0),clk=>clk,enable=>enb);
M2: Monoimpuls port map(btn=>btn(1),clk=>clk,enable=>rst);

process(clk,enb)
begin
if rising_edge(clk)then
if  enb='1' then
--if-id
reg_if_id(31 downto 16)<=instruction;
reg_if_id(15 downto 0)<=next_instruction;

--id-ex
reg_id_ex(82 downto 67)<=reg_if_id(15 downto 0);
reg_id_ex(66)<=mem_to_reg;
reg_id_ex(65)<=reg_write;
reg_id_ex(64)<=mem_write;
reg_id_ex(63)<=branch;
reg_id_ex(62 downto 60)<=alu_op;
reg_id_ex(59)<=alu_src;
reg_id_ex(58)<=reg_dest;
reg_id_ex(57 downto 42)<=rd1;
reg_id_ex(41 downto 26)<=rd2;
reg_id_ex(25 downto 10)<=ext_imm;
reg_id_ex(9 downto 7)<=funct;
reg_id_ex(6)<=sa;
reg_id_ex(5 downto 3)<=rd;
reg_id_ex(2 downto 0)<=rt;

--ex-mem

reg_ex_mem(55)<=reg_id_ex(66);
reg_ex_mem(54)<=reg_id_ex(65);
reg_ex_mem(53)<=reg_id_ex(64);
reg_ex_mem(52)<=reg_id_ex(63);
reg_ex_mem(51)<=zero;
reg_ex_mem(50 downto 35)<=branch_address;
reg_ex_mem(34 downto 19)<=alu_result;
reg_ex_mem(18 downto 16)<=rWa;
reg_ex_mem(15 downto 0)<=reg_id_ex(41 downto 26);

--mem-wb
reg_mem_wb(36)<=reg_ex_mem(55);
reg_mem_wb(35)<=reg_ex_mem(54);
reg_mem_wb(34 downto 19)<=alu_result_out;
reg_mem_wb(18 downto 3)<=mem_data;
reg_mem_wb(2 downto 0)<=reg_ex_mem(18 downto 16);
end if;
end if;
end process;

I: InstructionFetch port map(clk=>clk,jmp=>jump,jmp_addr=>jmp_address,pcsrc=>pc_src,branch_addr=>reg_ex_mem(50 downto 35),en=>enb,rst=>rst,next_instr=>next_instruction,instr=>instruction);
MC: Main_Control port map(instr=>reg_if_id(31 downto 16),reg_dst=>reg_dest,ext_op=>ext_op,alu_src=>alu_src,branch=>branch,jmp=>jump,alu_op=>alu_op,mem_write=>mem_write,mem_to_reg=>mem_to_reg,reg_write=>reg_write);
ID:Instruction_Decoder port map(reg_write=>reg_mem_wb(35),instr=>reg_if_id(31 downto 16),clk=>clk,en=>enb,ext_op=>ext_op,wd=>write_data,wa=>reg_mem_wb(2 downto 0),rdata1=>rd1,rdata2=>rd2,ext_imm=>ext_imm,funct=>funct,sa=>sa,rd=>rd,rt=>rt);
E: EX port map(rd1=>reg_id_ex(57 downto 42),alu_src=>reg_id_ex(59),rd2=>reg_id_ex(41 downto 26),ext_imm=>reg_id_ex(25 downto 10),sa=>reg_id_ex(6),funct=>reg_id_ex(9 downto 7),alu_op=>reg_id_ex(62 downto 60),next_instr=>reg_id_ex(82 downto 67),zero=>zero,alu_res=>alu_result,branch_address=>branch_address,rd=>reg_id_ex(5 downto 3),rt=>reg_id_ex(2 downto 0),reg_dest=>reg_id_ex(58),rWa=>rWa);
MEMORY: MEM port map(mem_write=>mem_write,alu_res=>reg_ex_mem(34 downto 19),rd2=>reg_ex_mem(15 downto 0),clk=>clk,en=>enb,mem_data=>mem_data,alu_res_out=>alu_result_out);

   write_data <= reg_mem_wb(34 downto 19) when (reg_mem_wb(36)= '0') else reg_mem_wb(18 downto 3);
    jmp_address<=reg_if_id(15 downto 13)&reg_if_id(28 downto 16);
    pc_src<=reg_ex_mem(51) and reg_ex_mem(52);

process(sw,instruction,rd1,rd2,ext_imm,alu_result,next_instruction,mem_data,write_data)
begin
case sw(7 downto 5) is
when "000"=>data<=instruction;
when "001"=>data<=next_instruction;
when "010"=>data<=reg_id_ex(57 downto 42);
--data<=rd1;
when "011"=>data<=reg_id_ex(41 downto 26);
--data<=rd2;
when "100"=>data<=reg_id_ex(25 downto 10);
--data<=ext_imm;
when "101"=>data<=alu_result;
when "110"=>data<=mem_data;
when "111"=>data<=write_data;
end case;
end process;

S: SSD port map(digit0=>data(3 downto 0),digit1=>data(7 downto 4),digit2=>data(11 downto 8),digit3=>data(15 downto 12),clk=>clk,an=>an,cat=>cat);

led(0)<=reg_mem_wb(35);
led(1)<=reg_mem_wb(36);
led(2)<=reg_ex_mem(53);
led(3)<=jump;
led(4)<=reg_ex_mem(52);
led(5)<=reg_id_ex(59);
led(6)<=ext_op;
led(7)<=reg_id_ex(58);
led(10 downto 8)<=alu_op;


end Behavioral;