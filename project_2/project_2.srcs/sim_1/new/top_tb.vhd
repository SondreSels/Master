library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_TopModule is
end tb_TopModule;

architecture testbench of tb_TopModule is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal startpos : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal endpos : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal start : STD_LOGIC := '0';
    signal output_data : STD_LOGIC_VECTOR(31 downto 0);
    signal done : STD_LOGIC;

    constant clk_period : time := 10 ns; -- Adjust the period as needed

    component TopModule
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            startpos : in STD_LOGIC_VECTOR(15 downto 0);
            endpos : in STD_LOGIC_VECTOR(15 downto 0);
            start : in STD_LOGIC;
            output_data : out std_logic_vector(31 downto 0);
            done : out std_logic
        );
    end component;

    begin
        uut : TopModule
        port map (
            clk => clk,
            reset => reset,
            startpos => startpos,
            endpos => endpos,
            start => start,
            output_data => output_data,
            done => done
        );

        clock_process: process
        begin
            while now < 10000 ns loop  -- Simulate for 5000 ns
                clk <= '0';
                wait for clk_period / 2;
                clk <= '1';
                wait for clk_period / 2;
            end loop;
            wait;
        end process;

        stimulus_process: process
        begin
            -- Initialize
            reset <= '1';
            wait for 50 ns;
            reset <= '0';
            wait for 10 ns;
            -- set startpos to (2,2)
            startpos <= "0000001000000010";
            -- set endpos to (5,5)
            endpos <= "0000011000000110";
            

            -- Start the algorithm
            start <= '1';
            wait for 10 ns;
            start <= '0';

            wait for 5000 ns;  -- Simulate for 5000 ns


            wait;

        end process stimulus_process;

end testbench;
