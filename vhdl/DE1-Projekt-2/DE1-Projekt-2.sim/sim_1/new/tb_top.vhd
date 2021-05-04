----------------------------------------------------------------------------------
-- Company: Matej Nanko
-- Engineer: Matej Nanko
-- 
-- Create Date: 03/23/2021 05:38:59 PM
-- Design Name: 
-- Module Name: tb_top - Behavioral
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

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is
constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
signal s_CLK100MHZ : STD_LOGIC;                      
signal s_BTN  : STD_LOGIC;                    
signal s_JA   : STD_LOGIC_VECTOR (8 - 1 downto 0);  
signal s_JB   : STD_LOGIC_VECTOR (4 - 1 downto 0);  
signal s_JD   : STD_LOGIC;                          
signal s_row  : STD_LOGIC_VECTOR (4 - 1 downto 0);  
signal s_col  : STD_LOGIC_VECTOR (4 - 1 downto 0);

begin
    uut_top : entity work.top
        port map(
            CLK100MHZ     => s_CLK100MHZ,
            BTN   => s_BTN,
            JA  => s_JA,
            JB  => s_JB,
            JD  => s_JD,
            row => s_row,
            col => s_col
            );
            
    p_clk_gen : process
    begin
        while now < 18000 ns loop         -- 75 periods of 100MHz clock
            s_CLK100MHZ <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_CLK100MHZ <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        s_BTN <= '1';
        wait for 50 ns;
        s_BTN <= '0';
        wait for 50 ns;
        
        s_row <= "1101";     --1st char  (7)
        wait for 500 ns;
        
        s_row <= "1111";    --release
        wait for 600 ns;
        
        s_row <= "0111";     --2nd char (3)
        wait for 500 ns;
        
        s_row <= "1111";     --release
        wait for 300 ns;
        
        s_row <= "1011";     --3rd char (5)
        wait for 500 ns;
        
        s_row <= "1111";     --release
        wait for 300 ns;
        
        s_row <= "1110";     --4rd char (0)
        wait for 500 ns;
        
        s_row <= "1111";     --release
        wait for 300 ns;
        
    wait;
    end process p_stimulus;

end Behavioral;
