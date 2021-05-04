----------------------------------------------------------------------------------
-- Company: Matej Nanko
-- Engineer: Matej Nanko
-- 
-- Create Date: 04/20/2021 04:16:20 PM
-- Design Name: keypad module 
-- Module Name: keypad - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision: 1.0
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keypad is
Port 
    (
    clk     : in  std_logic;
    reset   : in  std_logic;
    col_o   : out STD_LOGIC_VECTOR (4 - 1 downto 0);
    row_i   : in STD_LOGIC_VECTOR (4 - 1 downto 0);
    hex_o   : out STD_LOGIC_VECTOR (4 - 1 downto 0)
    );
end keypad;

architecture Behavioral of keypad is

    type t_state is (COL_1,  --(1 4 7 0)
                     COL_2,  --(2 5 8 F)
                     COL_3,  --(3 6 9 E)
                     COL_4   --(A B C D)
                     );
                     
    signal s_state  : t_state;
    signal s_en     : std_logic;
    signal s_cnt    : unsigned(5 - 1 downto 0);
    signal r_hex: STD_LOGIC_VECTOR (4 - 1 downto 0);
    
    constant c_DELAY_50ms : unsigned(5 - 1 downto 0) := b"0_1001";
    constant c_ZERO       : unsigned(5 - 1 downto 0) := b"0_0000";
begin

    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX => 1--000000       -- g_MAX = 10 ms / (1/100 MHz) 
        )
        port map(
            clk   => clk,
            reset => reset,
            ce_o  => s_en
        );
    p_keypad_timer : process(clk)
    variable s_hex: STD_LOGIC_VECTOR (4 - 1 downto 0);
    begin
        if rising_edge (clk) then
        s_hex :=r_hex;
            if (reset = '1') then       -- Synchronous reset
                s_state <= COL_1;      -- Set initial state
                s_cnt <= c_ZERO;
                
            elsif (s_en = '1') then
                case s_state is
                     when COL_1 =>
                        if(s_cnt < c_DELAY_50ms) then   --change collum every 50 ms 
                            s_cnt <= s_cnt + 1;
                        else
                            if (s_hex = "1111") then    --wait if there is output to lock
                                s_state <= COL_2;
                                s_cnt <= c_ZERO;
                            else
                                s_state <= COL_1;       --if yes go wait in this step
                            end if;
                        end if;
                     when COL_2 =>
                        if(s_cnt < c_DELAY_50ms) then
                            s_cnt <= s_cnt + 1;
                        else
                            if (s_hex = "1111") then
                                s_state <= COL_3;
                                s_cnt <= c_ZERO;
                            else
                                s_state <= COL_2;
                            end if;
                        end if;
                     when COL_3 =>
                        if(s_cnt < c_DELAY_50ms) then
                            s_cnt <= s_cnt + 1;
                        else
                            if (s_hex = "1111") then
                                s_state <= COL_4;
                                s_cnt <= c_ZERO;
                            else
                                s_state <= COL_3;
                            end if;
                        end if;
                     when COL_4 =>
                        if(s_cnt < c_DELAY_50ms) then
                            s_cnt <= s_cnt + 1;
                        else
                            if (s_hex = "1111") then
                                s_state <= COL_1;
                                s_cnt <= c_ZERO;
                            else
                                s_state <= COL_4;
                            end if;
                        end if;
                end case; 

                case s_state is
                     when COL_1 =>
                        col_o <= "0111";            --collum signal
                        if(row_i ="0111") then      --setting row input with keypad
                            s_hex := "0001";    --1
                        elsif(row_i ="1011") then
                            s_hex := "0100";    --4
                        elsif(row_i ="1101") then
                            s_hex := "0111";    --7
                        elsif(row_i ="1110") then
                            s_hex := "0000";    --0
                        else
                            s_hex := "1111";
                        end if;
                     when COL_2 =>
                        col_o <= "1011";
                        if(row_i ="0111") then
                            s_hex := "0010";    --2
                        elsif(row_i ="1011") then
                            s_hex := "0101";    --5
                        elsif(row_i ="1101") then
                            s_hex := "1000";    --8
--                        elsif(row_i ="1110") then
--                            s_hex := "1111";    --F
                        else
                            s_hex := "1111";
                        end if;
                     when COL_3 =>
                        col_o <= "1101";
                        if(row_i ="0111") then
                            s_hex := "0011";    --3
                        elsif(row_i ="1011") then
                            s_hex := "0110";    --6
                        elsif(row_i ="1101") then
                            s_hex := "1001";    --9
--                        elsif(row_i ="1110") then
--                            s_hex := "1110";    --E we are not using this
                        else
                            s_hex := "1111";
                        end if;
                     when COL_4 =>
                        col_o <= "1110";
                        if(row_i ="0111") then
                            s_hex := "1010";    --A (deleting of previous character)
                        elsif(row_i ="1011") then
                            s_hex := "1011";    --B (delete everything)
--                        elsif(row_i ="1101") then
--                            s_hex := "1100";    --C we are not using this
--                        elsif(row_i ="1110") then
--                            s_hex := "1101";    --D we are not using this
                        else
                            s_hex := "1111";
                        end if;
        
                end case; 
            end if;
        end if;
    r_hex <= s_hex;
    end process p_keypad_timer;
    hex_o <= r_hex;
end Behavioral;