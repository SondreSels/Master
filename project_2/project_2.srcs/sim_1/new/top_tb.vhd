library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity tb_TopModule is
end tb_TopModule;

architecture testbench of tb_TopModule is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal startpos : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal endpos : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal start : STD_LOGIC := '0';
    signal output_data : STD_LOGIC_VECTOR(31 downto 0);
    signal out_pos : STD_LOGIC_VECTOR(15 downto 0);
    signal done : STD_LOGIC;
    signal came_from_pos : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    constant clk_period : time := 10 ns; -- Adjust the period as needed

    -- Testbench variable for storing all the different out_pos values
    type pos_array is array (0 to 5000) of std_logic_vector(15 downto 0);
    shared variable pos : pos_array;
    shared variable came_from : pos_array;
    -- index for the pos array
    shared variable pos_index : integer := 1;
    shared variable came_from_index : integer := 1;

    component TopModule
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            startpos : in STD_LOGIC_VECTOR(15 downto 0);
            endpos : in STD_LOGIC_VECTOR(15 downto 0);
            start : in STD_LOGIC;
            output_data : out std_logic_vector(31 downto 0);
            out_pos : out std_logic_vector(15 downto 0);
            done : out std_logic;
            came_from_pos : out std_logic_vector(15 downto 0)
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
            out_pos => out_pos,
            done => done,
            came_from_pos => came_from_pos
        );

        clock_process: process
        begin
            while now < 200000 ns loop  -- Simulate for 5000 ns
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
             -- set startpos to (18,22)
            startpos <= "0001001000010110";
            -- set endpos to (64,64)
            endpos <= "0100000001000000";
            wait for 150 ns;
            start <= '1';
            reset <= '0';
           
                       

            wait for 40 ns;
            start <= '0';

            wait for 5000 ns;  -- Simulate for 5000 ns

            wait;

        end process stimulus_process;

        -- When out_pos changes, store the value in the pos array
        pos_store: process
        begin
            while now < 200000 ns loop
                if out_pos /= pos(pos_index - 1) then
                    pos(pos_index) := out_pos;
                    pos_index := pos_index + 1;
                end if;
                wait for 1 ns;
            end loop;
            wait;
        end process;

        -- came_from_store: process
        -- begin
        --     wait until done = '1';
        --     while now < 200000 ns loop
        --         if came_from_pos = startpos then
        --             -- do nothing
        --         elsif came_from_pos = endpos then
        --             -- break out of the loop
        --             exit;
        --         elsif came_from_pos /= came_from(came_from_index - 1) then
        --             came_from(came_from_index) := came_from_pos;
        --             came_from_index := came_from_index + 1;
        --         end if;
        --         wait for 1 ns;
        --     end loop;
        -- end process;

        -- When the simulation is done, write the pos array to a file
        end_simulation: process
        file pos_file: text open write_mode is "pos.txt";
        file came_from_file: text open write_mode is "came_from.txt";
        -- line to write to the file
        variable l : line;
        variable line : line;
        begin
            while now < 200000 ns loop
                wait for 1 ns;
            end loop;
            -- write a test line to the file of a std_logic_vector to make sure it is workin
            for i in 1 to pos_index - 1 loop
                -- write the pos array to the file
                write(line, pos(i));
                writeline(pos_file, line);
            end loop;
            for i in 1 to came_from_index - 1 loop
                -- write the came_from array to the file
                write(l, came_from(i));
                writeline(came_from_file, l);
            end loop;
            wait;
        end process;
        
        

        

end testbench;
