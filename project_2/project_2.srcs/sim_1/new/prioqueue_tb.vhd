library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity priority_queue_tb is
end priority_queue_tb;

architecture Behavioral of priority_queue_tb is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal enqueue : STD_LOGIC := '0';
    signal dequeue : STD_LOGIC := '0';
    signal in_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal out_data : STD_LOGIC_VECTOR(31 downto 0);

    -- Instantiate the priority_queue component
    component priority_queue
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            enqueue : in STD_LOGIC;
            dequeue : in STD_LOGIC;
            in_data : in STD_LOGIC_VECTOR(31 downto 0);
            out_data : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

begin
    -- Instantiate the priority_queue module
    UUT: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue,
            dequeue => dequeue,
            in_data => in_data,
            out_data => out_data
        );

    -- Clock generation process
    process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Test process
    process
    begin
        reset <= '1'; -- Initial reset
        wait for 15 ns;
        reset <= '0'; -- Deassert reset
        wait for 100 ns;

        -- Test 1: Enqueue an element
        enqueue <= '1';
        in_data <= "00000000000000000000000000010000"; -- Example data
        wait for 10 ns;
        enqueue <= '0';
        
        -- Test 2: Dequeue an element
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';

        -- Test 3: Enqueue 4 elements
        wait for 20 ns;
        enqueue <= '1';
        in_data <= "00000000000000000000000000000100"; -- Example data
        wait for 10 ns;
        enqueue <= '0';
        wait for 10 ns;
        enqueue <= '1';
        in_data <= "00000000000000000000000000100000"; -- Example data
        wait for 10 ns;
        enqueue <= '0';
        wait for 10 ns;
        enqueue <= '1';
        in_data <= "00000000000000000000000000000110"; -- Example data
        wait for 10 ns;
        enqueue <= '0';
        wait for 10 ns;
        enqueue <= '1';
        in_data <= "00000000000000000000000000000010"; -- Example data
        wait for 10 ns;
        enqueue <= '0';

        -- Test 4: Enqueue 20 elements and dequeue 20 elements
        wait for 20 ns;
        enqueue <= '1';
        in_data <= "00000000000000000000000000001110"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000110000"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000001010"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000000001"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000000011"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000000111"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000001000"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000001001"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000001011"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000010010001100"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000001100"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000100001101"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000001101"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000010000000001111"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000010000"; -- Example data
        wait for 10 ns;
        in_data <= "00000000000000000000000000010001"; -- Example data
        wait for 10 ns;
        enqueue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        enqueue <= '1';
        in_data <= "00000000000000000000000000000010";
        wait for 10 ns;
        in_data <= "00000000000000000000000000000001";
        wait for 10 ns;
        in_data <= "00000000000000000000000000100001";
        wait for 10 ns;
        enqueue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait for 10 ns;
        dequeue <= '1';
        wait for 10 ns;
        dequeue <= '0';
        wait;
    end process;

end Behavioral;
