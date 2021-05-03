----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2021 09:14:39 PM
-- Design Name: 
-- Module Name: lock - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lock is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        keypad_i: in std_logic_vector(4 - 1 downto 0);
        data0_o : out  std_logic_vector(4 - 1 downto 0);
        data1_o : out  std_logic_vector(4 - 1 downto 0);
        data2_o : out  std_logic_vector(4 - 1 downto 0);
        data3_o : out  std_logic_vector(4 - 1 downto 0);
        door_o  : out  std_logic

    );
end lock;

architecture Behavioral of lock is

    -- Define the states
    type t_state is (START,
                     PRESS1,
                     RELEASE1,
                     PRESS2,
                     RELEASE2,
                     PRESS3,
                     RELEASE3,
                     PRESS4,
                     RELEASE4
                     );
    -- Define the signal that uses different states
    signal s_state  : t_state;

    -- Internal clock enable
    signal s_en     : std_logic;
    -- Local delay counter

    signal   s_col      : STD_LOGIC_VECTOR (4 - 1 downto 0);
    signal   s_current  : STD_LOGIC_VECTOR(4 - 1 downto 0);

    signal   s_correct  : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal   r_data0    : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal   r_data1    : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal   r_data2    : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal   r_data3    : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal   r_door     : std_logic;

    -- Specific values for local counter
    constant c_ZERO       : STD_LOGIC_VECTOR(4 - 1 downto 0) := b"1111";

begin
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX => 10       -- g_MAX = 10 ms / (1/100 MHz) 
        )
        port map(
            clk   => clk,
            reset => reset,
            ce_o  => s_en
        );
    p_lock : process(clk)
    variable   s_display  : STD_LOGIC_VECTOR(4 - 1 downto 0);
    variable   s_door     : std_logic;
    
    begin
        if rising_edge(clk) then
        s_door := r_door;
            if (reset = '1') then       -- Synchronous reset
                s_state <= START ;      -- Set initial state
                s_door := '1';
                s_current <= "1111";
                s_display := "0000";
                
            elsif (s_en = '1') then
                case s_state is
                
                    when START =>
                        if (keypad_i = "1111" or keypad_i = "1010" or  keypad_i = "1011") then
                            s_current   <= c_ZERO;
                        else
                            s_state <= PRESS1;
                            s_current <= keypad_i;
                            s_display := keypad_i;
                        end if;

                    when PRESS1 =>
                        if (s_current = keypad_i) then
                            s_display := s_current;
                        else
                            if (s_current = "0111") then  --7
                                s_correct(0) <= '1';
                            elsif (s_current = "1010") then
                                s_state <= START;
                                s_correct <= "0000";
                            elsif (s_current = "1011") then
                                s_state <= START;
                                s_correct <= "0000";
                            end if;
                            s_state <= RELEASE1;
                            s_current   <= c_ZERO;
                        end if;
                        
                    when RELEASE1 =>
                        if (keypad_i = "1111" or keypad_i = "1010") then
                            s_current   <= c_ZERO;
                        else
                            s_state <= PRESS2;
                            s_current <= keypad_i;
                            s_display := keypad_i;
                        end if;
                        
                    when PRESS2 =>
                        if (s_current = keypad_i) then
                            s_display := s_current;
                        else
                            if (s_current = "0011") then    --3
                                s_correct(1) <= '1';
                            elsif (s_current = "1010") then
                                s_state <= START;
                                s_correct(0) <= '0';
                            elsif (s_current = "1011") then
                                s_state <= START;
                                s_correct <= "0000";
                            end if;
                            s_state <= RELEASE2;
                            s_current   <= c_ZERO;
                        end if;
                        
                    when RELEASE2 =>
                        if (keypad_i = "1111" or keypad_i = "1010") then
                            s_current   <= c_ZERO;
                        else
                            s_state <= PRESS3;
                            s_current <= keypad_i;
                            s_display := keypad_i;
                        end if;
                        
                    when PRESS3 =>
                        if (s_current = keypad_i) then
                            s_display := s_current;
                        else
                            if (s_current = "0101") then    --5
                                s_correct(2) <= '1';
                            elsif (s_current = "1010") then
                                s_state <= RELEASE1;
                                s_correct(1) <= '0';
                            elsif (s_current = "1011") then
                                s_state <= START;
                                s_correct <= "0000";
                            end if;
                            s_state <= RELEASE3;
                            s_current   <= c_ZERO;
                        end if;
                        
                    when RELEASE3 =>
                        if (keypad_i = "1111") then
                            s_current   <= c_ZERO;
                        else
                            s_state <= PRESS4;
                            s_current <= keypad_i;
                            s_display := keypad_i;
                        end if;
                        
                    when PRESS4 =>
                        if (s_current = keypad_i) then
                            s_display := s_current;
                        else
                            if (s_current = "0000") then    --0
                                s_correct(3) <= '1';
                            elsif (s_current = "1010") then
                                s_state <= RELEASE2;
                                s_correct(2) <= '0';
                            elsif (s_current = "1011") then
                                s_state <= START;
                                s_correct <= "0000";
                            end if;
                            s_state <= RELEASE4;
                            s_current   <= c_ZERO;
                        end if;
                        
                    when RELEASE4 =>
                        if (s_correct = "1111") then
                            if (s_door = '1') then
                                s_door := '0';
                                else
                                s_door := '1';
                                end if;
                            s_state <= START;
                            s_correct <= "0000";
                            s_display := "1111";
                        else
                            s_state <= START;
                            s_correct <= "0000";
                            s_display := "1111";
                        end if;

                    -- It is a good programming practice to use the 
                    -- OTHERS clause, even if all CASE choices have 
                    -- been made. 
                    when others =>
                        s_state <= START;

                end case;
            end if; -- Synchronous reset


        case s_state is
            when PRESS1 =>
                r_data3 <= s_display;
            when PRESS2 =>
                r_data2 <= s_display;
            when PRESS3 =>
                r_data1 <= s_display;
            when PRESS4 =>
                r_data0 <= s_display;
            when START =>
                r_data0 <= s_current;
                r_data1 <= s_current;
                r_data2 <= s_current;
                r_data3 <= s_current;
            when others =>
                

        end case;
        end if; -- Rising edge
        r_door <= s_door;
        end process p_lock;
        data0_o <= r_data0;
        data1_o <= r_data1;
        data2_o <= r_data2;
        data3_o <= r_data3;
        door_o  <= r_door;
        
end Behavioral;
