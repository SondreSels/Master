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
        enqueue_1 : in STD_LOGIC;
        enqueue_2 : in STD_LOGIC;
        enqueue_3 : in STD_LOGIC;
        enqueue_4 : in STD_LOGIC;
        out_data : out STD_LOGIC_VECTOR(31 downto 0);
        ena_g_scores : in STD_LOGIC;
        enb_g_scores : in STD_LOGIC;
        wea_g_scores : in STD_LOGIC;
        web_g_scores : in STD_LOGIC;
        addra_g_scores : in STD_LOGIC_VECTOR(15 downto 0);
        addrb_g_scores : in STD_LOGIC_VECTOR(15 downto 0);
        dia_g_scores : in STD_LOGIC_VECTOR(31 downto 0);
        doa_g_scores : out STD_LOGIC_VECTOR(31 downto 0);
        dib_g_scores : in STD_LOGIC_VECTOR(31 downto 0);
        dob_g_scores : out STD_LOGIC_VECTOR(31 downto 0);
        dob_closed_list : out STD_LOGIC_VECTOR(0 downto 0)
    );
end TopModule;

architecture Behavioral of TopModule is
    signal dequeue_1 : std_logic;
    signal dequeue_2 : std_logic;
    signal dequeue_3 : std_logic;
    signal dequeue_4 : std_logic;
    signal out_data_comp : std_logic_vector(31 downto 0);
    signal out_data_pq_1, out_data_pq_2, out_data_pq_3, out_data_pq_4 : std_logic_vector(31 downto 0);
    signal out_data_g_scores : std_logic_vector(31 downto 0);
    signal out_data_closed_list : std_logic_vector(0 downto 0);
    signal step : STD_LOGIC := '0';
    signal ena_closed_list : STD_LOGIC;
    signal enb_closed_list : STD_LOGIC;
    signal wea_closed_list : STD_LOGIC;
    signal addra_closed_list : STD_LOGIC_VECTOR(15 downto 0);
    signal addrb_closed_list : STD_LOGIC_VECTOR(15 downto 0);
    signal dia_closed_list : STD_LOGIC_VECTOR(0 downto 0);
    signal last_out_data_comp : std_logic_vector(31 downto 0) := (others => '0');  -- To store the last output value from the comparator
    signal neighbor_1 : std_logic_vector(15 downto 0);
    signal neighbor_2 : std_logic_vector(15 downto 0);
    signal neighbor_3 : std_logic_vector(15 downto 0);
    signal neighbor_4 : std_logic_vector(15 downto 0);

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

    component g_scores
        Port (
            clk : in std_logic;
            ena : in std_logic;
            enb : in std_logic;
            wea : in std_logic;
            web : in std_logic;
            addra : in std_logic_vector(15 downto 0);
            addrb : in std_logic_vector(15 downto 0);
            dia : in std_logic_vector(31 downto 0);
            doa : out std_logic_vector(31 downto 0);
            dib : in std_logic_vector(31 downto 0);
            dob : out std_logic_vector(31 downto 0)
        );
    end component;

    component closed_list
        Port (
            clk : in std_logic;
            ena : in std_logic;
            enb : in std_logic;
            wea : in std_logic;
            addra : in std_logic_vector(15 downto 0);
            addrb : in std_logic_vector(15 downto 0);
            dia : in std_logic_vector(0 downto 0);
            dob : out std_logic_vector(0 downto 0)
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

    -- Instantiate g_scores memory module
    g_scores_inst: g_scores
        port map (
            clk => clk,
            ena => ena_g_scores,
            enb => enb_g_scores,
            wea => wea_g_scores,
            web => web_g_scores,
            addra => addra_g_scores,
            addrb => addrb_g_scores,
            dia => dia_g_scores, 
            doa => doa_g_scores,
            dib => dib_g_scores, 
            dob => dob_g_scores
        );

    -- Instantiate closed_list memory module
    closed_list_inst: closed_list
        port map (
            clk => clk,
            ena => ena_closed_list,
            enb => enb_closed_list,
            wea => wea_closed_list,
            addra => addra_closed_list,
            addrb => addrb_closed_list,
            dia => dia_closed_list,  
            dob => dob_closed_list
        );

    -- Output the result
    out_data <= out_data_comp;

    -- Toggle step and write '1' to closed_list when the output from the comparator changes
    process(clk)
    begin
        if rising_edge(clk) then
            if out_data_comp /= last_out_data_comp then
                step <= not step;  -- Toggle step
                ena_closed_list <= '1';
                wea_closed_list <= '1';
                addra_closed_list <= out_data_comp(31 downto 16);
                dia_closed_list <= "1";  -- Write '1' to the specified address
                neighbor_1 <= out_data_comp(15 downto 0) + "0001";
                neighbor_2 <= out_data_comp(15 downto 0) - "0001";
                neighbor_3 <= out_data_comp(15 downto 0) + "0100";
                neighbor_4 <= out_data_comp(15 downto 0) - "0100";
            else
                ena_closed_list <= '0';
                wea_closed_list <= '0';
            end if;
            
            last_out_data_comp <= out_data_comp;
        end if;
    end process;

end Behavioral;
