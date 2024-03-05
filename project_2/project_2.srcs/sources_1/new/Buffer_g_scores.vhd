----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.02.2024 17:28:38
-- Design Name: 
-- Module Name: Buffer_g_scores - Behavioral
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

entity Buffer_g_scores is
    Port (
        clk : in std_logic;
        in_buff_1 : in std_logic_vector(31 downto 0);
        in_buff_2 : in std_logic_vector(31 downto 0);
        in_buff_3 : in std_logic_vector(31 downto 0);
        in_buff_4 : in std_logic_vector(31 downto 0);
        read_addr : in std_logic_vector(15 downto 0);
        out_data : out std_logic_vector(31 downto 0)
     );
end Buffer_g_scores;

architecture Behavioral of Buffer_g_scores is
    type state_type is (one, two, three, four);
    signal state : state_type;
    signal wea: std_logic := '0';
    signal enb : std_logic := '1';
    signal addra : std_logic_vector(15 downto 0);
    signal dia, dob : std_logic_vector(31 downto 0);
    signal buff_1, buff_2, buff_3, buff_4 : std_logic_vector(31 downto 0) := (others => '0');
    signal g_scores_out : std_logic_vector(31 downto 0) := (others => '0');

component g_scores
        Port (
            clk : in std_logic;
            enb : in std_logic;
            wea : in std_logic;
            addra : in std_logic_vector(15 downto 0);
            addrb : in std_logic_vector(15 downto 0);
            dia : in std_logic_vector(31 downto 0);
            dob : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    g_scores_1: g_scores port map (
        clk => clk,
        enb => enb,
        wea => wea,
        addra => addra,
        addrb => read_addr,
        dia => dia,
        dob => dob
    );


    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when one =>
                    wea <= '1';
                    addra <= buff_1(31 downto 16);
                    dia <= buff_1;
                    state <= two;
                when two =>
                    wea <= '1';
                    addra <= buff_2(31 downto 16);
                    dia <= buff_2;
                    state <= three;
                when three =>
                    wea <= '1';
                    addra <= buff_3(31 downto 16);
                    dia <= buff_3;
                    state <= four;
                when four =>
                    wea <= '1';
                    addra <= buff_4(31 downto 16);
                    dia <= buff_4;
                    state <= one;
            end case;
            buff_1 <= in_buff_1;
            buff_2 <= in_buff_2;
            buff_3 <= in_buff_3;
            buff_4 <= in_buff_4;
        end if;
    end process;

    process(clk, read_addr)
    begin
        if rising_edge(clk) then
            if read_addr = buff_1(31 downto 16) then
                g_scores_out <= buff_1;
            elsif read_addr = buff_2(31 downto 16) then
                g_scores_out <= buff_2;
            elsif read_addr = buff_3(31 downto 16) then
                g_scores_out <= buff_3;
            elsif read_addr = buff_4(31 downto 16) then
                g_scores_out <= buff_4;
            else
                -- Get the data from the g_scores
                g_scores_out <= dob;
            end if;
        end if;
    end process;
    out_data <= g_scores_out;


end Behavioral;
