----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2024 14:41:25
-- Design Name: 
-- Module Name: FSM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input_1 : in  STD_LOGIC_VECTOR(31 downto 0);
           input_2 : in  STD_LOGIC_VECTOR(31 downto 0);
           input_3 : in  STD_LOGIC_VECTOR(31 downto 0);
           input_4 : in  STD_LOGIC_VECTOR(31 downto 0);
           a_output_addr : out  STD_LOGIC_VECTOR(15 downto 0);
           a_output_data : out  STD_LOGIC_VECTOR(31 downto 0);
           a_enable : out  STD_LOGIC;
           a_write : out  STD_LOGIC;
           b_output_addr : out  STD_LOGIC_VECTOR(15 downto 0);
           b_output_data : out  STD_LOGIC_VECTOR(31 downto 0);
           b_enable : out  STD_LOGIC;
           b_write : out  STD_LOGIC
           );
end FSM;

architecture Behavioral of FSM is
    signal state : std_logic_vector(1 downto 0) := "00";
    signal next_state : std_logic_vector(1 downto 0) := "00";
    signal prev_input : std_logic_vector(31 downto 0) := (others => '0');
    signal count : std_logic_vector(1 downto 0) := (others => '0');

begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= "00";
        elsif rising_edge(clk) then
            state <= next_state;
            prev_input <= input_1;
            if state = "01" then
                count <= count + 1;
            else
                count <= "00";
            end if;
        end if;
    end process;

    process(state, input_1)
    begin
        case state is
            when "00" =>
                if input_1 /= prev_input then
                    next_state <= "01";
                else
                    next_state <= "00";
                end if;
            when "01" =>
                if count = "10" then
                    next_state <= "00";
                else
                    next_state <= "01";
                end if;
            when others =>
                next_state <= "00";
        end case;
    end process;

    process(state)
    begin
        case state is
            when "00" =>
                a_output_addr <= input_3(31 downto 16);
                a_output_data <= input_3;
                a_enable <= '1';
                a_write <= '1';
                b_output_addr <= input_4(31 downto 16);
                b_output_data <= input_4;
                b_enable <= '1';
                b_write <= '1';
            when "01" =>
                a_output_addr <= input_1(31 downto 16);
                a_output_data <= input_1;
                a_enable <= '1';
                a_write <= '1';
                b_output_addr <= input_2(31 downto 16);
                b_output_data <= input_2;
                b_enable <= '1';
                b_write <= '1';
            when others =>
                a_enable <= '0';
                a_write <= '0';
                b_enable <= '0';
                b_write <= '0';
        end case;
    end process;


end Behavioral;
