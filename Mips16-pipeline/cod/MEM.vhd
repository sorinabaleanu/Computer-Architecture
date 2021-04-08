----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2020 06:32:38 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( mem_write : in STD_LOGIC;
           alu_res : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           mem_data : out STD_LOGIC_VECTOR (15 downto 0);
           alu_res_out : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type registru is array (0 to 31) of std_logic_vector(15 downto 0);
signal mem:registru;
signal address:std_logic_vector(4 downto 0);
begin
 address<=alu_res(4 downto 0);
process(clk)
begin
if rising_edge(clk) then
if en='1' and mem_write='1' then
mem(conv_integer(address))<=rd2;
end if;
end if;
end process;

mem_data<=mem(conv_integer(address));
alu_res_out<=alu_res;
end Behavioral;
