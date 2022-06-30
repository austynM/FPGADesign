----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2022 02:49:31 PM
-- Design Name: 
-- Module Name: final_mem - mem_arch
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity final_mem is
generic ( x : integer  := 8;
          y : integer  := 12);
           
Port ( clk :in std_logic; 
       we :in std_logic;
       addrX : in std_logic_vector(x-1 downto 0);
       addrY : in std_logic_vector(y-1 downto 0);
       di : out std_logic_vector(2 downto 0);
       do : in std_logic_vector(2 downto 0)  );
end final_mem;

architecture mem_arch of final_mem is
    type ram_type is array (x-1 downto 0, y-1 downto 0) of std_logic_vector(2 downto 0);
    signal RAM : ram_type := ((others => (others => "000")));
begin
    process(clk)
    begin
          RAM(5, 8) <= "011"; 
          RAM(4, 1) <= "010";
          RAM(1, 0) <= "010";
          RAM(2, 1) <= "010";
          RAM(1, 1) <= "010";
          RAM(0, 1) <= "010";
        if rising_edge(clk) then 
            if(we = '1') then
                RAM(CONV_INTEGER(addrX), CONV_INTEGER(addrY)) <= do;
                di <= do;
            else 
                di <= RAM(CONV_INTEGER(addrX), CONV_INTEGER (addrY));
           end if; end if;
         end process;
end mem_arch;
