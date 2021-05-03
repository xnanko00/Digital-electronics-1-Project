----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2021 05:41:45 PM
-- Design Name: 
-- Module Name: tb_keypad - Behavioral
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

entity tb_keypad is
--  Port ( );
end tb_keypad;

architecture testbench of tb_keypad is
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    signal s_clk_100MHz : std_logic;
    signal s_reset      : std_logic;
    signal s_col   : std_logic_vector (4 - 1 downto 0);
    signal s_row   : std_logic_vector (4 - 1 downto 0);
    signal s_hex   : std_logic_vector (4 - 1 downto 0);

begin

    uut_keypad : entity work.keypad
        port map(
        clk     => s_clk_100MHz,
        reset   => s_reset,
        col_o   => s_col,
        row_i   => s_row,
        hex_o   => s_hex
        );
        
    p_clk_gen : process
    begin
        while now < 6000 ns loop         -- 75 periods of 100MHz clock
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        s_reset <= '1';
        wait for 50 ns;
        s_reset <= '0';
        wait for 50 ns;
        
        s_row <= "0111";    -- output should be 1
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 450 ns;
        s_row <= "0111";    -- output should be 2
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 90 ns;
        s_row <= "0111";    --output should be 3
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 150 ns;
        s_row <= "1011";    -- output should be 4
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 90 ns;
        s_row <= "1011";    -- output should be 5
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 90 ns;    
        s_row <= "1011";    --output should be 6
        wait for 150 ns;
        s_row <= "1111";

        wait for 150 ns;    -- output should be 7
        s_row <= "1101";
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 90 ns;   -- output should be 8
        s_row <= "1101";    
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 90 ns;    -- output should be 9
        s_row <= "1101";
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 150 ns;    --output should be 0
        s_row <= "1110";
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 250 ns;    -- output should be A
        s_row <= "0111";
        wait for 150 ns;
        s_row <= "1111";
        
        wait for 350 ns;    --output should be B
        s_row <= "1011";
        wait for 150 ns;
        s_row <= "1111";
        
        
       
    wait;
    end process p_stimulus;
end architecture testbench;