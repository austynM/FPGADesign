----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 03:53:05 PM
-- Design Name: 
-- Module Name: top_level_wrap - wrap_arch
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

entity top_level_wrap is
generic ( x : integer := 8;
          y : integer := 12 );
          
Port ( clk : in std_logic;
       start : in std_logic;
       reset : in std_logic;
       done : out std_logic;
       impossiableSig : out std_logic );
end top_level_wrap;

architecture wrap_arch of top_level_wrap is
       signal we : std_logic;
       signal addrX : std_logic_vector(x-1 downto 0);
       signal addrY : std_logic_vector(y-1 downto 0);
       signal di, do : std_logic_vector(2 downto 0); 
begin
       mem: entity work.final_mem(mem_arch)
            port map(clk => clk, we => we, addrX => addrX,
                     addrY => addrY, di => di, do => do);
                     
       fsm: entity work.robotFSM(robotArch)
            port map(clk => clk, reset => reset, we => we,
                     start => start, done => done, addrX => addrX,
                     addrY => addrY, di => di, do => do, impossiableSig => impossiableSig);


end wrap_arch;
