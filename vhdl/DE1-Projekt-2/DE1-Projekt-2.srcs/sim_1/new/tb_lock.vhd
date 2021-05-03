----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2021 03:44:54 PM
-- Design Name: 
-- Module Name: tb_lock - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

entity tb_lock is

end entity tb_lock;

architecture testbench of tb_lock is
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    signal s_clk_100MHz : std_logic;
    signal s_reset      : std_logic;
    signal s_keypad     : std_logic_vector(4 - 1 downto 0);
    signal s_data0      : std_logic_vector(4 - 1 downto 0);
    signal s_data1      : std_logic_vector(4 - 1 downto 0);
    signal s_data2      : std_logic_vector(4 - 1 downto 0);
    signal s_data3      : std_logic_vector(4 - 1 downto 0);
    signal s_door       : std_logic;


begin

    uut_lock : entity work.lock
        port map(
        clk     => s_clk_100MHz,
        reset   => s_reset,
        keypad_i=> s_keypad,
        data0_o => s_data0,
        data1_o => s_data1,
        data2_o => s_data2,
        data3_o => s_data3,
        door_o  => s_door
        );
        
    p_clk_gen : process
    begin
        while now < 18000 ns loop         -- 75 periods of 100MHz clock
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
        
        s_keypad <= "0101";     --1st char
        wait for 500 ns;
        
        s_keypad <= "1111";     --release
        wait for 500 ns;
        
        s_keypad <= "1000";     --2nd char
        wait for 500 ns;
        
        s_keypad <= "1111";     --release
        wait for 500 ns;
        
        s_keypad <= "1011";     --delete everything
        wait for 500 ns;
        
        s_keypad <= "1111";     --release
        wait for 500 ns;
        
        s_keypad <= "0101";     --1st char
        wait for 500 ns;
        
        s_keypad <= "1111";     --release
        wait for 500 ns;
        
        s_keypad <= "1000";     --2nd char
        wait for 500 ns;
        
        s_keypad <= "1111";     --release
        wait for 500 ns;
        
        s_keypad <= "1010";     --delete 2nd char
        wait for 500 ns;
        
        s_keypad <= "1111";     --release
        wait for 500 ns;
        
        s_keypad <= "1000";     --2nd char
        wait for 500 ns;
        
        s_keypad <= "1111";     --release
        wait for 500 ns;
        
        s_keypad <= "0100";     --3rd char
        wait for 500 ns;
        
        s_keypad <= "1111";     --release
        wait for 500 ns;
        
        s_keypad <= "0000";     --4th char
        wait for 500 ns;
        
        s_keypad <= "1111";     --zly kod
        wait for 500 ns;   
        
        s_keypad <= "0111";
        wait for 500 ns;
        
        s_keypad <= "1111";
        wait for 500 ns;
        
        s_keypad <= "0011";
        wait for 500 ns;
        
        s_keypad <= "1111";
        wait for 500 ns;
        
        s_keypad <= "0101";
        wait for 500 ns;
        
        s_keypad <= "1111";
        wait for 500 ns;
        
        s_keypad <= "0000";
        wait for 500 ns;
        
        s_keypad <= "1111";     --otvorene dvere
        wait for 500 ns;
        
        s_keypad <= "0111";
        wait for 500 ns;
        
        s_keypad <= "1111";
        wait for 500 ns;
        
        s_keypad <= "0011";
        wait for 500 ns;
        
        s_keypad <= "1111";
        wait for 500 ns;
        
        s_keypad <= "0101";
        wait for 500 ns;
        
        s_keypad <= "1111";
        wait for 500 ns;
        
        s_keypad <= "0000";
        wait for 500 ns;
        
        s_keypad <= "1111";     --zatvorene dvere
        wait for 500 ns;

        
    wait;
    end process p_stimulus;
end architecture testbench;