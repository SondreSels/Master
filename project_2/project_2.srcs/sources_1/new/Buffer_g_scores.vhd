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
        reset : in std_logic;
        in_buff_1 : in std_logic_vector(31 downto 0);
        in_buff_2 : in std_logic_vector(31 downto 0);
        in_buff_3 : in std_logic_vector(31 downto 0);
        in_buff_4 : in std_logic_vector(31 downto 0);
        came_from_1 : in std_logic_vector(15 downto 0);
        came_from_2 : in std_logic_vector(15 downto 0);
        came_from_3 : in std_logic_vector(15 downto 0);
        came_from_4 : in std_logic_vector(15 downto 0);
        g_score_1 : in std_logic_vector(15 downto 0);
        g_score_2 : in std_logic_vector(15 downto 0);
        g_score_3 : in std_logic_vector(15 downto 0);
        g_score_4 : in std_logic_vector(15 downto 0);
        enqueue_1 : out std_logic;
        enqueue_2 : out std_logic;
        enqueue_3 : out std_logic;
        enqueue_4 : out std_logic;
        read_addr : in std_logic_vector(15 downto 0);
        out_data : out std_logic_vector(31 downto 0)
     );
end Buffer_g_scores;

architecture Behavioral of Buffer_g_scores is
    type state_type is (one, two, three, four, five, six, seven, eight, idle);
    signal state : state_type;
    signal next_state : state_type;
    signal wea: std_logic := '0';
    signal enb : std_logic := '1';
    signal ena : std_logic := '1';
    signal addra : std_logic_vector(15 downto 0);
    signal dia, dob, doa : std_logic_vector(31 downto 0);
    signal g_scores_out : std_logic_vector(31 downto 0) := (others => '0');
    signal prev_enqueue_1, prev_enqueue_2, prev_enqueue_3, prev_enqueue_4 : std_logic := '0';
    


component g_scores
        Port (
            clk : in std_logic;
            enb : in std_logic;
            ena : in std_logic;
            wea : in std_logic;
            addra : in std_logic_vector(15 downto 0);
            addrb : in std_logic_vector(15 downto 0);
            dia : in std_logic_vector(31 downto 0);
            doa : out std_logic_vector(31 downto 0);
            dob : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    g_scores_1: g_scores port map (
        clk => clk,
        enb => enb,
        ena => ena,
        wea => wea,
        addra => addra,
        addrb => read_addr,
        dia => dia,
        doa => doa,
        dob => dob
    );

    enqueue_1 <= prev_enqueue_1;
    enqueue_2 <= prev_enqueue_2;
    enqueue_3 <= prev_enqueue_3;
    enqueue_4 <= prev_enqueue_4;

    process(clk, reset)
    begin
        if reset = '1' then
            state <= one;
        elsif rising_edge(clk) then
            case state is
                when one =>
                    wea <= '0';
                    addra <= in_buff_1(31 downto 16);
                    next_state <= two;
                    state <= idle;
                when two =>
                    if doa(15 downto 0) >= g_score_1 then
                        wea <= '1';
                        dia(31 downto 16) <= came_from_1;
                        dia(15 downto 0) <= in_buff_1(15 downto 0);
                        prev_enqueue_1 <= not prev_enqueue_1;
                    else
                        wea <= '0';
                    end if;
                    next_state <= three;
                    state <= idle;
                when three =>
                    wea <= '0';
                    addra <= in_buff_2(31 downto 16);
                    next_state <= four;
                    state <= idle;
                when four =>
                    if doa(15 downto 0) >= g_score_2 then
                        wea <= '1';
                        dia(31 downto 16) <= came_from_2;
                        dia(15 downto 0) <= in_buff_2(15 downto 0);
                        prev_enqueue_2 <= not prev_enqueue_2;
                    else
                        wea <= '0';
                    end if;
                    next_state <= five;
                    state <= idle;
                when five =>
                    wea <= '0';
                    addra <= in_buff_3(31 downto 16);
                    next_state <= six;
                    state <= idle;
                when six =>
                    if doa(15 downto 0) >= g_score_3 then
                        wea <= '1';
                        dia(31 downto 16) <= came_from_3;
                        dia(15 downto 0) <= in_buff_3(15 downto 0);
                        prev_enqueue_3 <= not prev_enqueue_3;
                    else
                        wea <= '0';
                    end if;
                    next_state <= seven;
                    state <= idle;
                when seven =>
                    wea <= '0';
                    addra <= in_buff_4(31 downto 16);
                    next_state <= eight;
                    state <= idle;
                when eight =>
                    if doa(15 downto 0) >= g_score_4 then
                        wea <= '1';
                        dia(31 downto 16) <= came_from_4;
                        dia(15 downto 0) <= in_buff_4(15 downto 0);
                        prev_enqueue_4 <= not prev_enqueue_4;
                    else
                        wea <= '0';
                    end if;
                    next_state <= one;
                    state <= idle;
                when idle =>
                    state <= next_state;
            end case;
        end if;
    end process;

    process(clk, read_addr)
    begin
        if rising_edge(clk) then
            if read_addr = in_buff_1(31 downto 16) then
                g_scores_out(31 downto 16) <= came_from_1;
                g_scores_out(15 downto 0) <= in_buff_1(15 downto 0);
            elsif read_addr = in_buff_2(31 downto 16) then
                g_scores_out(31 downto 16) <= came_from_2;
                g_scores_out(15 downto 0) <= in_buff_2(15 downto 0);
            elsif read_addr = in_buff_3(31 downto 16) then
                g_scores_out(31 downto 16) <= came_from_3;
                g_scores_out(15 downto 0) <= in_buff_3(15 downto 0);
            elsif read_addr = in_buff_4(31 downto 16) then
                g_scores_out(31 downto 16) <= came_from_4;
                g_scores_out(15 downto 0) <= in_buff_4(15 downto 0);
            else
                -- Get the data from the g_scores
                g_scores_out <= dob;
            end if;
        end if;
    end process;
    out_data <= g_scores_out;


end Behavioral;
