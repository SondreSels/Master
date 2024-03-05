library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Buffer_g_scores_tb is
end Buffer_g_scores_tb;

architecture Behavioral of Buffer_g_scores_tb is
    signal clk_tb : std_logic := '0';
    signal in_buff_1_tb, in_buff_2_tb, in_buff_3_tb, in_buff_4_tb : std_logic_vector(31 downto 0) := (others => '0');
    signal read_addr_tb : std_logic_vector(15 downto 0) := (others => '0');
    signal out_data_tb : std_logic_vector(31 downto 0);

    component Buffer_g_scores
        Port (
            clk : in std_logic;
            in_buff_1 : in std_logic_vector(31 downto 0);
            in_buff_2 : in std_logic_vector(31 downto 0);
            in_buff_3 : in std_logic_vector(31 downto 0);
            in_buff_4 : in std_logic_vector(31 downto 0);
            read_addr : in std_logic_vector(15 downto 0);
            out_data : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    UUT: Buffer_g_scores port map (
        clk => clk_tb,
        in_buff_1 => in_buff_1_tb,
        in_buff_2 => in_buff_2_tb,
        in_buff_3 => in_buff_3_tb,
        in_buff_4 => in_buff_4_tb,
        read_addr => read_addr_tb,
        out_data => out_data_tb
    );

    clk_process: process
    begin
        while now < 1000 ns loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stimulus_process: process
    begin
        -- set the input buffers where the first 16 bits are the address and the last 16 bits are the data, input_1 be address 3,3 and data 40
        in_buff_1_tb <= "00000011000000110000000000101000";
        -- input_2 be address 3,4 and data 50
        in_buff_2_tb <= "00000011000001000000000000110010";
        -- input_3 be address 3,5 and data 60
        in_buff_3_tb <= "00000011000001010000000000111100";
        -- input_4 be address 3,6 and data 70
        in_buff_4_tb <= "00000011000001100000000001000110";
        wait for 50 ns;
        -- set the read address to 3,3 using 16 bits
        read_addr_tb <= "0000001100000011";
        wait for 10 ns;
        -- now feed in 4 new inputs and then read one of the old ones
        -- input_1 be address 4,3 and data 80
        in_buff_1_tb <= "00000100000000110000000001010000";
        -- input_2 be address 4,4 and data 90
        in_buff_2_tb <= "00000100000001000000000001011010";
        -- input_3 be address 4,5 and data 100
        in_buff_3_tb <= "00000100000001010000000001100100";
        -- input_4 be address 4,6 and data 110
        in_buff_4_tb <= "00000100000001100000000001101110";
        wait for 50 ns;
        -- set the read address to 3,4
        read_addr_tb <= "0000001100000100";
        wait for 30 ns;
        -- set the read address to 4,3
        read_addr_tb <= "0000010000000011";
        wait for 10 ns;
        -- give 4 more inputs
        -- input_1 be address 5,3 and data 120
        in_buff_1_tb <= "00000101000000110000000001111000";
        -- input_2 be address 5,4 and data 130
        in_buff_2_tb <= "00000101000001000000000010000010";
        -- input_3 be address 5,5 and data 140
        in_buff_3_tb <= "00000101000001010000000010001100";
        -- input_4 be address 5,6 and data 150
        in_buff_4_tb <= "00000101000001100000000010010110";
        wait for 50 ns;
        -- set the read address to 4,4
        read_addr_tb <= "0000010000000100";
        wait for 30 ns;
        -- set the read address to 5,3
        read_addr_tb <= "0000010100000011";

        wait;
    end process;

end Behavioral;
