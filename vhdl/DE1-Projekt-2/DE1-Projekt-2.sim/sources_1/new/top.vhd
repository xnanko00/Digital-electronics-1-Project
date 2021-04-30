----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 04:12:11 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTN : in STD_LOGIC_VECTOR;
           JA : OUT STD_LOGIC_VECTOR (8 - 1 downto 0);
           JB : out STD_LOGIC_VECTOR (4 - 1 downto 0);
           row : IN  STD_LOGIC_VECTOR (4 - 1 downto 0);
           col : out  STD_LOGIC_VECTOR (4 - 1 downto 0);
           JD : OUT STD_LOGIC_VECTOR);
           
end top;

architecture Behavioral of top is
    -- No internal signals
    signal  s_keypad  : std_logic_vector(4 - 1 downto 0);
    signal  s_data0     :std_logic_vector(4-1 downto 0);
    signal  s_data1     :std_logic_vector(4-1 downto 0);
    signal  s_data2     :std_logic_vector(4-1 downto 0);
    signal  s_data3     :std_logic_vector(4-1 downto 0);
    
begin
    --------------------------------------------------------------------
    -- Instance (copy) of driver_7seg_4digits entity
    keypad : entity work.keypad
        port map(
            --- WRITE YOUR CODE HERE
            clk     => CLK100MHZ,
            reset   => btn(0),
            hex_o   => s_keypad,
            row_i   => row,
            col_o   => col
        );
        
    lock : entity work.lock
        port map(
            --- WRITE YOUR CODE HERE
            clk      => CLK100MHZ,
            reset    => btn(0),
            keypad_i => s_keypad,
            data0_o  => s_data0,
            data1_o  => s_data1,
            data2_o  => s_data2,
            data3_o  => s_data3,
            door_o   => JD
        );

    driver_seg_4 : entity work.driver_7seg_4digits
        port map(
            clk        => CLK100MHZ,
            reset      => BTN(0),
            data0_i => s_data0,
            data1_i => s_data1,
            data2_i => s_data2,
            data3_i => s_data3,
            
            dp_i => "1111",
            --- WRITE YOUR CODE HERE
            seg_o(6) => JA(0),
            seg_o(5) => JA(1),
            seg_o(4) => JA(2),
            seg_o(3) => JA(3),
            seg_o(2) => JA(4),
            seg_o(1) => JA(5),
            seg_o(0) => JA(6),
            dp_o     => JA(7),
            
            dig_o => JB(4 - 1 downto 0)
        );

end architecture Behavioral;