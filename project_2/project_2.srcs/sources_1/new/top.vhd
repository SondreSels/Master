library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TopModule is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        in_data_1 : in STD_LOGIC_VECTOR(31 downto 0);
        in_data_2 : in STD_LOGIC_VECTOR(31 downto 0);
        in_data_3 : in STD_LOGIC_VECTOR(31 downto 0);
        in_data_4 : in STD_LOGIC_VECTOR(31 downto 0);
        step : in STD_LOGIC;
        enqueue_1 : in STD_LOGIC;
        enqueue_2 : in STD_LOGIC;
        enqueue_3 : in STD_LOGIC;
        enqueue_4 : in STD_LOGIC;
        out_data : out STD_LOGIC_VECTOR(31 downto 0)
    );
end TopModule;

architecture Behavioral of TopModule is
    signal dequeue_1 : std_logic;
    signal dequeue_2 : std_logic;
    signal dequeue_3 : std_logic;
    signal dequeue_4 : std_logic;
    signal out_data_comp : std_logic_vector(31 downto 0);
    signal out_data_pq_1, out_data_pq_2, out_data_pq_3, out_data_pq_4 : std_logic_vector(31 downto 0);

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

    component SmallestValueComparator
        Port (
            clk : in  std_logic;
            input_1 : in  std_logic_vector(31 downto 0);
            input_2 : in  std_logic_vector(31 downto 0);
            input_3 : in  std_logic_vector(31 downto 0);
            input_4 : in  std_logic_vector(31 downto 0);
            dequeue_1 : out std_logic;
            dequeue_2 : out std_logic;
            dequeue_3 : out std_logic;
            dequeue_4 : out std_logic;
            output_data : out std_logic_vector(31 downto 0);
            step : in std_logic
        );
    end component;


begin
    -- Instantiate 4 priority_queue modules
    priority_queue_1: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue_1,
            dequeue => dequeue_1,
            in_data => in_data_1,
            out_data => out_data_pq_1
        );

    priority_queue_2: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue_2,
            dequeue => dequeue_2,
            in_data => in_data_2,
            out_data => out_data_pq_2
        );

    priority_queue_3: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue_3,
            dequeue => dequeue_3,
            in_data => in_data_3,
            out_data => out_data_pq_3
        );

    priority_queue_4: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue_4,
            dequeue => dequeue_4,
            in_data => in_data_4,
            out_data => out_data_pq_4
        );

    -- Instantiate SmallestValueComparator module
    comparator_inst: SmallestValueComparator
        port map (
            clk => clk,
            input_1 => out_data_pq_1,
            input_2 => out_data_pq_2,
            input_3 => out_data_pq_3,
            input_4 => out_data_pq_4,
            dequeue_1 => dequeue_1,
            dequeue_2 => dequeue_2,
            dequeue_3 => dequeue_3,
            dequeue_4 => dequeue_4,
            output_data => out_data_comp,
            step => step
        );

    -- Output the result
    out_data <= out_data_comp;

end Behavioral;
