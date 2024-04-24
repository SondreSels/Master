library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity priority_queue is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enqueue : in STD_LOGIC;
           dequeue : in STD_LOGIC;
           in_data : in STD_LOGIC_VECTOR(31 downto 0);
           out_data : out STD_LOGIC_VECTOR(31 downto 0));
end priority_queue;

architecture Behavioral of priority_queue is
    component queue_block
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               dequeue : in STD_LOGIC;
               to_temp_prev : out STD_LOGIC_VECTOR(31 downto 0);
               to_queue_prev : out STD_LOGIC_VECTOR(31 downto 0);
               from_temp_next : in STD_LOGIC_VECTOR(31 downto 0);
               from_queue_next : in STD_LOGIC_VECTOR(31 downto 0);
               temp_prev : in STD_LOGIC_VECTOR(31 downto 0);
               temp_next : out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    constant QUEUE_DEPTH : integer := 254; -- Example value, adjust as needed
     -- Declare signals for connections between instances
    type data_t is array(0 to QUEUE_DEPTH) of STD_LOGIC_VECTOR(31 downto 0);
    signal to_queue_prev_signals : data_t := (others => (others => '1'));
    signal to_temp_prev_signals : data_t := (others => (others => '1'));
    signal temp_prev_signals : data_t := (others => (others => '1'));
    signal temp_0 : STD_LOGIC_VECTOR(31 downto 0) := (others => '1');
    signal queue_0 : STD_LOGIC_VECTOR(31 downto 0) := (others => '1');
    signal temp_n : STD_LOGIC_VECTOR(31 downto 0) := (others => '1');
    signal queue_n : STD_LOGIC_VECTOR(31 downto 0) := (others => '1');
    signal prev_dequeue : STD_LOGIC := '0';
    signal to_block_dequeue : STD_LOGIC := '0';
    signal prev_enqueue : STD_LOGIC := '0';


begin
    -- Instantiate 100 instances of queue_block
    gen_blocks: for i in 0 to QUEUE_DEPTH-1 generate
        queue_block_inst : queue_block
            port map (
                clk => clk,
                reset => reset,
                dequeue => to_block_dequeue,
                to_temp_prev => to_temp_prev_signals(i),
                to_queue_prev => to_queue_prev_signals(i),
                from_temp_next => to_temp_prev_signals(i+1),
                from_queue_next => to_queue_prev_signals(i+1),
                temp_prev => temp_prev_signals(i),
                temp_next => temp_prev_signals(i+1)
            );
    end generate;
    process (clk, reset)
    begin
        if reset = '1' then
            -- Initialize queue and temp
            queue_0 <= (others => '1');
            temp_0 <= (others => '1');
            queue_n <= (others => '1');
            temp_n <= (others => '1');
            prev_dequeue <= '0';
        elsif rising_edge(clk) then
            if to_block_dequeue = '1' then
                to_block_dequeue <= '0';
            end if;
            -- if dequeue is different from previous cycle
            if prev_dequeue /= dequeue then
                queue_0 <= to_queue_prev_signals(0);
                temp_0 <= to_temp_prev_signals(0);
                queue_n <= (others => '1');
                temp_n <= (others => '1');
                prev_dequeue <= dequeue;
                to_block_dequeue <= '1';
            else
                if prev_enqueue /= enqueue then
                    if in_data(15 downto 0) <= queue_0(15 downto 0) then
                        queue_0 <= in_data;
                        temp_0 <= queue_0;
                    else
                        temp_0 <= in_data;
                    end if;
                    prev_enqueue <= enqueue;
                else
                    temp_0 <= (others => '1');
                end if;
                if temp_prev_signals(QUEUE_DEPTH)(15 downto 0) <= queue_n(15 downto 0) then
                    queue_n <= temp_prev_signals(QUEUE_DEPTH);
                    temp_n <= queue_n;
                else
                    temp_n <= temp_prev_signals(QUEUE_DEPTH);
                end if;
            end if;
        end if;
    end process;
    out_data <= queue_0;
    to_temp_prev_signals(QUEUE_DEPTH) <= temp_n;
    to_queue_prev_signals(QUEUE_DEPTH) <= queue_n;
    temp_prev_signals(0) <= temp_0;
end Behavioral;
