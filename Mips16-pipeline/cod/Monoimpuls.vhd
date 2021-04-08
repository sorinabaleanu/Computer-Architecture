----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2020 04:53:14 PM
-- Design Name: 
-- Module Name: Monoimpuls - Behavioral
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

entity Monoimpuls is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end Monoimpuls;

architecture Behavioral of Monoimpuls is

signal count:std_logic_vector (15 downto 0):="0000000000000000";
signal Q1:std_logic;
signal Q2:std_logic;
signal Q3:std_logic;

begin

  
  process(clk)
  begin
  if rising_edge(clk) then
  count<=count+1;
  end if;
  end process;
  
  process(clk)
  begin
  if rising_edge(clk) then
    if count="1111111111111111" then
       Q1<=btn;
    end if;
  end if;
  end process;
  
  process(clk)
  begin
  if rising_edge(clk) then
  Q2<=Q1;
  Q3<=Q2;
  end if;
  end process;
  
  enable<=not Q3 and Q2;


end Behavioral;
