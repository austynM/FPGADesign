----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2022 05:04:04 PM
-- Design Name: 
-- Module Name: robotFSM - robotArch
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

entity robotFSM is
generic ( x : integer := 8;
          y : integer := 12);
          
Port ( clk : in std_logic;
       reset : in std_logic;
       we : out std_logic;
       start : in std_logic;
       done : out std_logic;
       impossiableSig : out std_logic;
       addrX : out std_logic_vector(x-1 downto 0);
       addrY : out std_logic_vector(y-1 downto 0);
       di : in std_logic_vector(2 downto 0);
       do : out std_logic_vector(2 downto 0));
end robotFSM;

architecture robotArch of robotFSM is
    type state_type is (init, startState, doneState,  
                        updateN, updateE, updateS, updateW, 
                        updateMem, setMem, resetWe, resetAddr,
                        checkN,  checkE,  checkS,  checkW,
                        checkNB, checkEB, checkSB, checkWB,
                        checkNC, checkEC, checkSC, checkWC,
                        checkND, checkED, checkSD, checkWD,
                        checkNwait, checkEwait, checkSwait, checkWwait,
                        backTrack, checkDone, 
                        bcheckN,  bcheckE,  bcheckS,  bcheckW,
                        bcheckNB, bcheckEB, bcheckSB, bcheckWB,
                        bcheckNC, bcheckEC, bcheckSC, bcheckWC,
                        bcheckND, bcheckED, bcheckSD, bcheckWD,
                        updateNb, updateEb, updateSb, updateWb,
                        bcheckNwait, bcheckEwait, bcheckSwait, bcheckWwait, 
                        updateMemB, impossiable
                        ); 
   signal state : state_type;
begin
    process(clk)
    constant maxX : std_logic_vector(x-1 downto 0) := (others => '1');
    constant maxY : std_logic_vector(y-1 downto 0) := (others => '1');
    variable currX, prevX : std_logic_vector (x-1 downto 0);
    variable currY, prevY : std_logic_vector (y-1 downto 0);
    variable posData : std_logic_vector(2 downto 0);
    begin 
        if rising_edge(clk) then
            if reset = '1' then
                currX := std_logic_vector(to_unsigned(0, currX'length));
                currY := std_logic_vector(to_unsigned(y-1, currY'length));
                prevX := (others => '0');
                prevY := (others => '0');
                we <= '0';
                done <= '0';
                impossiableSig <= '0';
                state <= init;
            else
                case state is 
                    when init => 
                        if start = '1' then
                            addrX <= std_logic_vector(currX);
                            addrY <= std_logic_vector(currY);
                            state <= startState;
                        else 
                            state <= init;
                        end if;
                   when startState =>
                            state <= checkN;
                   when doneState =>
                            done <= '1';
                                                        
                   when checkN =>
                         if (currY - 1 = maxY) then 
                            state <= checkE;
                         else 
                            state <= checkNB;
                         end if;
                   when checkNB => 
                            addrY <= currY - 1;
                            state <= checkNwait;
                   when checkNwait =>
                            state <= checkNC;
                   when checkNC => 
                            posData := di;
                            state <= checkND;
                   when checkND =>
                            if di = 1 or di = 2 or di = 4 then
                                addrY <= currY;
                                state <= checkE;
                            else if di = 0 or di = 3 then
                                currY := currY - 1; 
                                state <= updateN;
                            end if; end if; 
                            
                   when checkE => 
                           if currX + 1 >= x then 
                                state <= checkS;
                           else
                                state <= checkEB;
                           end if;
                   when checkEB =>
                            addrX <= currX + 1;                                             
                            state <= checkEwait; 
                   when checkEwait => 
                            state <= checkEC;                     
                   when checkEC => 
                            posData := di;
                            state <= checkED;
                   when checkED => 
                            if di = 1 or di = 2 or di = 4 then 
                                addrX <= currX;
                                state <= checkS;
                            else if di = 0 or di = 3 then 
                                currX := currX + 1;
                                state <= updateE;
                            end if; end if;
                            
                  when checkS => 
                            if currY + 1 >= y then 
                                state <= checkW;
                            else 
                                state <= checkSB;
                            end if;
                   when checkSB => 
                            addrY <= currY + 1;
                            state <= checkSwait;
                   when checkSwait => 
                            state <= checkSC;       
                   when checkSC => 
                            posData := di;
                            state <= checkSD;
                   when checkSD => 
                            if di = 1 or di = 2 or di = 4 then
                                addrY <= currY; 
                                state <= checkW;
                            else if di = 0 or di = 3 then
                                currY := currY + 1;
                                state <= updateS;
                            end if; end if;
                            
                   when checkW => 
                            if (currX - 1 = maxX)  then 
                                state <= backTrack;
                            else 
                                state <= checkWB;
                            end if;
                   when checkWB => 
                            addrX <= currX - 1;
                            state <= checkWwait;
                   when checkWwait => 
                            state <= checkWC;        
                   when checkWC => 
                            posData := di;
                            state <= checkWD;
                   when checkWD => 
                            if di = 1 or di = 2 or di = 4 then 
                                addrX <= currX;
                                state <= backTrack;
                            else if di = 0 or di = 3 then
                                currX := currX - 1;
                                state <= updateW;
                            end if; end if;
                            
                   when updateN => 
                            prevX := currX; 
                            prevY := currY + 1; 
                            state <= updateMem;
                   when updateE => 
                            prevX := currX - 1; 
                            prevY := currY;
                            state <= updateMem;
                   when updateS => 
                            prevX := currX; 
                            prevY := currY - 1; 
                            state <= updateMem;                          
                   when updateW => 
                            prevX := currX + 1; 
                            prevY := currY;
                            state <= updateMem;
                   when updateMem =>
                            we <= '1';
                            addrX <= std_logic_vector(prevX);
                            addrY <= std_logic_vector(prevY);
                            do <= "001";
                            state <= setMem;
                   when setMem =>
                            state <= resetWe;
                   when resetWe =>
                            we <= '0';
                            state <= resetAddr;
                   when resetAddr => 
                            addrX <= currX;
                            addrY <= currY; 
                            state <= checkDone;
                   when checkDone => 
                            if di = 3 then 
                                state <= doneState;
                            else 
                                state <= startState;
                            end if;                    
                   when backTrack => 
                            state <= bcheckW;
                            
                   when bcheckW => 
                            if (currX - 1 = maxX) then 
                                state <= bcheckS;
                            else 
                                state <= bcheckWB;
                            end if;
                   when bcheckWB => 
                            addrX <= currX - 1;
                            state <= bcheckWwait;
                   when bcheckWwait => 
                            state <= bcheckWC;        
                   when bcheckWC => 
                            posData := di;
                            state <= bcheckWD;
                   when bcheckWD => 
                            if di = 2 or di = 4 then 
                                addrX <= currX;
                                state <= bcheckS;
                            else if di = 1 then 
                                currX := currX - 1;
                                state <= updateWb;
                            else if di = 0 then 
                                addrX <= currX;
                                state <= checkW;
                            end if; end if; end if;
                            
                   when bcheckS => 
                            if currY + 1 >= y then 
                                state <= bcheckE;
                            else 
                                state <= bcheckSB;
                            end if;
                   when bcheckSB => 
                            addrY <= currY + 1;
                            state <= bcheckSwait;
                   when bcheckSwait => 
                            state <= bcheckSC;       
                   when bcheckSC => 
                            posData := di;
                            state <= bcheckSD;
                   when bcheckSD => 
                            if di = 2 or di = 4 then
                                addrY <= currY;
                                state <= bcheckE;
                            else if di = 1 then 
                                currY := currY + 1;
                                state <= updateSb;
                            else if di = 0 then 
                                addrY <= currY;
                                state <= checkS;
                            end if; end if; end if;
                            
                   when bcheckE => 
                           if currX + 1 >= x then 
                                state <= bcheckN;
                           else
                                state <= bcheckEB;
                           end if;
                   when bcheckEB =>
                            addrX <= currX + 1;                                             
                            state <= bcheckEwait; 
                   when bcheckEwait => 
                            state <= bcheckEC;                     
                   when bcheckEC => 
                            posData := di;
                            state <= bcheckED;
                   when bcheckED => 
                            if di = 2 or di = 4 then 
                                addrX <= currX;
                                state <= bcheckN;
                            else if di = 1 then
                                currX := currX + 1;
                                state <= updateEb;
                            else if di = 0 then 
                                addrX <= currX;
                                state <= checkE;
                            end if; end if; end if;                 
                   
                   when bcheckN =>
                         if (currY - 1 = maxY) then 
                            state <= impossiable;
                         else 
                            state <= bcheckNB;
                         end if;
                   when bcheckNB => 
                            addrY <= currY - 1;
                            state <= bcheckNwait;
                   when bcheckNwait =>
                            state <= bcheckNC;
                   when bcheckNC => 
                            posData := di;
                            state <= bcheckND;
                   when bcheckND =>
                            if di = 2 or di = 4 then
                                addrY <= currY;
                                state <= impossiable;
                            else if di = 1 then
                                currY := currY - 1;
                                state <= updateNb;
                            else if di = 0 then 
                                addrY <= currY;
                                state <= checkN;
                            end if; end if; end if;
                            
                   when updateNb => 
                            prevX := currX; 
                            prevY := currY + 1; 
                            state <= updateMemB;
                   when updateEb => 
                            prevX := currX - 1; 
                            prevY := currY;
                            state <= updateMemB;
                   when updateSb => 
                            prevX := currX; 
                            prevY := currY - 1; 
                            state <= updateMemB;                          
                   when updateWb => 
                            prevX := currX + 1; 
                            prevY := currY;
                            state <= updateMemB;
                   when updateMemB =>
                            we <= '1';
                            addrX <= std_logic_vector(prevX);
                            addrY <= std_logic_vector(prevY);
                            do <= "100";
                            state <= setMem;
                                                                           
                   when impossiable =>
                            impossiableSig <= '1';


end case;
end if; end if;
end process;
end robotArch;
