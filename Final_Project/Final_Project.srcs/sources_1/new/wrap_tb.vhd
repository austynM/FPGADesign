----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 04:02:03 PM
-- Design Name: 
-- Module Name: wrap_tb - tb_arch
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wrap_tb is
end wrap_tb;

architecture tb_arch of wrap_tb is
    signal clk, start, done, reset, impossiableSig : std_logic;
begin
    
    top: entity work.top_level_wrap(wrap_arch)
         port map(clk => clk, start => start, done => done,
                  reset => reset, impossiableSig => impossiableSig);
                  
    process 
    begin
        clk <= '0';
        wait for 1ns;
        clk <= '1';
        wait for 1ns;
   end process;
   
   process 
   begin
        reset <= '1';
        wait for 4ns;
        reset <= '0';
        wait;
   end process;
   
   process 
   begin 
        wait for 12ns;
        start <= '1';
        wait for 4ns;
        start <= '0';
        wait;
   end process;    



end tb_arch;
