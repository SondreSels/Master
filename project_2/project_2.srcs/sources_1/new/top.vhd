library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopModule is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        startpos : in STD_LOGIC_VECTOR(15 downto 0);
        endpos : in STD_LOGIC_VECTOR(15 downto 0);
        start : in STD_LOGIC;
        output_data : out std_logic_vector(31 downto 0);
        done : out std_logic
    );
end TopModule;

architecture Behavioral of TopModule is
    signal dequeue_1 : std_logic;
    signal dequeue_2 : std_logic;
    signal dequeue_3 : std_logic;
    signal dequeue_4 : std_logic;
    signal enqueue_1 : std_logic;
    signal enqueue_2 : std_logic;
    signal enqueue_3 : std_logic;
    signal enqueue_4 : std_logic;
    signal in_data_1 : std_logic_vector(31 downto 0);
    signal in_data_2 : std_logic_vector(31 downto 0);
    signal in_data_3 : std_logic_vector(31 downto 0);
    signal in_data_4 : std_logic_vector(31 downto 0);
    signal out_data : std_logic_vector(31 downto 0);
    signal out_data_comp : std_logic_vector(31 downto 0) := (others => '1');
    signal out_data_pq_1, out_data_pq_2, out_data_pq_3, out_data_pq_4 : std_logic_vector(31 downto 0);
    signal out_data_g_scores : std_logic_vector(31 downto 0);
    signal out_data_closed_list : std_logic_vector(0 downto 0);
    signal step : STD_LOGIC := '0';
    signal ena_g_scores : STD_LOGIC;
    signal enb_g_scores : STD_LOGIC;
    signal wea_g_scores : STD_LOGIC;
    signal web_g_scores : STD_LOGIC;
    signal addra_g_scores : STD_LOGIC_VECTOR(15 downto 0);
    signal addrb_g_scores : STD_LOGIC_VECTOR(15 downto 0);
    signal dia_g_scores : STD_LOGIC_VECTOR(31 downto 0);
    signal doa_g_scores : std_logic_vector(31 downto 0);
    signal dob_g_scores : std_logic_vector(31 downto 0);
    signal dib_g_scores : std_logic_vector(31 downto 0);
    signal ena_closed_list_1 : STD_LOGIC;
    signal enb_closed_list_1 : STD_LOGIC := '1';
    signal wea_closed_list_1 : STD_LOGIC;
    signal addra_closed_list_1 : STD_LOGIC_VECTOR(15 downto 0);
    signal addrb_closed_list_1 : STD_LOGIC_VECTOR(15 downto 0);
    signal dia_closed_list_1 : STD_LOGIC_VECTOR(0 downto 0);
    signal dob_closed_list_1 : std_logic_vector(0 downto 0);
    signal ena_closed_list_2 : STD_LOGIC;
    signal enb_closed_list_2 : STD_LOGIC := '1';
    signal wea_closed_list_2 : STD_LOGIC;
    signal addra_closed_list_2 : STD_LOGIC_VECTOR(15 downto 0);
    signal addrb_closed_list_2 : STD_LOGIC_VECTOR(15 downto 0);
    signal dia_closed_list_2 : STD_LOGIC_VECTOR(0 downto 0);
    signal dob_closed_list_2 : std_logic_vector(0 downto 0);
    signal ena_closed_list_3 : STD_LOGIC;
    signal enb_closed_list_3 : STD_LOGIC := '1';
    signal wea_closed_list_3 : STD_LOGIC;
    signal addra_closed_list_3 : STD_LOGIC_VECTOR(15 downto 0);
    signal addrb_closed_list_3 : STD_LOGIC_VECTOR(15 downto 0);
    signal dia_closed_list_3 : STD_LOGIC_VECTOR(0 downto 0);
    signal dob_closed_list_3 : std_logic_vector(0 downto 0);
    signal ena_closed_list_4 : STD_LOGIC;
    signal enb_closed_list_4 : STD_LOGIC := '1';
    signal wea_closed_list_4 : STD_LOGIC;
    signal addra_closed_list_4 : STD_LOGIC_VECTOR(15 downto 0);
    signal addrb_closed_list_4 : STD_LOGIC_VECTOR(15 downto 0);
    signal dia_closed_list_4 : STD_LOGIC_VECTOR(0 downto 0);
    signal dob_closed_list_4 : std_logic_vector(0 downto 0);
    signal neighbor_1 : std_logic_vector(15 downto 0);
    signal neighbor_2 : std_logic_vector(15 downto 0);
    signal neighbor_3 : std_logic_vector(15 downto 0);
    signal neighbor_4 : std_logic_vector(15 downto 0);
    signal score_out_1 : std_logic_vector(15 downto 0) := (others => '1');
    signal score_out_2 : std_logic_vector(15 downto 0) := (others => '1');
    signal score_out_3 : std_logic_vector(15 downto 0) := (others => '1');
    signal score_out_4 : std_logic_vector(15 downto 0) := (others => '1');
    signal g_score_1 : std_logic_vector(15 downto 0) := (others => '1');
    signal g_score_2 : std_logic_vector(15 downto 0) := (others => '1');
    signal g_score_3 : std_logic_vector(15 downto 0) := (others => '1');
    signal g_score_4 : std_logic_vector(15 downto 0) := (others => '1');
    signal read_a : std_logic := '0';
    signal read_addr : std_logic_vector(15 downto 0) := "0000000000000001";
    signal counter : unsigned(2 downto 0) := (others => '0');
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

    component FSM
        Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input_1 : in  STD_LOGIC_VECTOR(31 downto 0);
           input_2 : in  STD_LOGIC_VECTOR(31 downto 0);
           input_3 : in  STD_LOGIC_VECTOR(31 downto 0);
           input_4 : in  STD_LOGIC_VECTOR(31 downto 0);
           read_a : in  STD_LOGIC;
           read_addr : in  STD_LOGIC_VECTOR(15 downto 0);
           a_output_addr : out  STD_LOGIC_VECTOR(15 downto 0);
           a_output_data : out  STD_LOGIC_VECTOR(31 downto 0);
           a_enable : out  STD_LOGIC;
           a_write : out  STD_LOGIC;
           b_output_addr : out  STD_LOGIC_VECTOR(15 downto 0);
           b_output_data : out  STD_LOGIC_VECTOR(31 downto 0);
           b_enable : out  STD_LOGIC;
           b_write : out  STD_LOGIC
        );
    end component;

    component calc_score
        Port ( 
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        closed : in  STD_LOGIC;
        new_pos : in  STD_LOGIC_VECTOR (15 downto 0);
        endpos : in  STD_LOGIC_VECTOR (15 downto 0);
        score_in : in  STD_LOGIC_VECTOR (15 downto 0);
        score_out : out  STD_LOGIC_VECTOR (15 downto 0);
        g_score_out : out  STD_LOGIC_VECTOR (15 downto 0);
        enqueue : out  STD_LOGIC
    );
    end component;

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
    -- Instantiate buffer_g_scores module
    buffer_g_scores_inst: Buffer_g_scores
        port map (
            clk => clk,
            in_buff_1(31 downto 16) => neighbor_1,
            in_buff_1(15 downto 0) => g_score_1,
            in_buff_2(31 downto 16) => neighbor_2,
            in_buff_2(15 downto 0) => g_score_2,
            in_buff_3(31 downto 16) => neighbor_3,
            in_buff_3(15 downto 0) => g_score_3,
            in_buff_4(31 downto 16) => neighbor_4,
            in_buff_4(15 downto 0) => g_score_4,
            read_addr => read_addr,
            out_data => out_data_g_scores
        );
    
        
    calc_score_1: calc_score
        port map (
            clk => clk,
            reset => reset,
            closed => dob_closed_list_1(0),
            new_pos => neighbor_1,
            endpos => endpos,
            score_in => out_data_g_scores(15 downto 0),
            score_out => score_out_1,
            g_score_out => g_score_1,
            enqueue => enqueue_1
        );
    
    calc_score_2: calc_score
        port map (
            clk => clk,
            reset => reset,
            closed => dob_closed_list_2(0),
            new_pos => neighbor_2,
            endpos => endpos,
            score_in => out_data_g_scores(15 downto 0),
            score_out => score_out_2,
            g_score_out => g_score_2,
            enqueue => enqueue_2
        );

    calc_score_3: calc_score
        port map (
            clk => clk,
            reset => reset,
            closed => dob_closed_list_3(0),
            new_pos => neighbor_3,
            endpos => endpos,
            score_in => out_data_g_scores(15 downto 0),
            score_out => score_out_3,
            g_score_out => g_score_3,
            enqueue => enqueue_3
        );
    
    calc_score_4: calc_score
        port map (
            clk => clk,
            reset => reset,
            closed => dob_closed_list_4(0),
            new_pos => neighbor_4,
            endpos => endpos,
            score_in => out_data_g_scores(15 downto 0),
            score_out => score_out_4,
            g_score_out => g_score_4,
            enqueue => enqueue_4
        );
    -- Instantiate 4 priority_queue modules
    priority_queue_1: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue_1,
            dequeue => dequeue_1,
            in_data(31 downto 16) => neighbor_1,
            in_data(15 downto 0) => score_out_1,
            out_data => out_data_pq_1
        );

    priority_queue_2: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue_2,
            dequeue => dequeue_2,
            in_data(31 downto 16) => neighbor_2,
            in_data(15 downto 0) => score_out_2,
            out_data => out_data_pq_2
        );

    priority_queue_3: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue_3,
            dequeue => dequeue_3,
            in_data(31 downto 16) => neighbor_3,
            in_data(15 downto 0) => score_out_3,
            out_data => out_data_pq_3
        );

    priority_queue_4: priority_queue
        port map (
            clk => clk,
            reset => reset,
            enqueue => enqueue_4,
            dequeue => dequeue_4,
            in_data(31 downto 16) => neighbor_4,
            in_data(15 downto 0) => score_out_4,
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

    -- Instantiate closed_list memory module
    closed_list_1: closed_list
        port map (
            clk => clk,
            ena => ena_closed_list_1,
            enb => enb_closed_list_1,
            wea => wea_closed_list_1,
            addra => addra_closed_list_1,
            addrb => neighbor_1,
            dia => dia_closed_list_1,
            dob => dob_closed_list_1
        );
    
    closed_list_2: closed_list
        port map (
            clk => clk,
            ena => ena_closed_list_2,
            enb => enb_closed_list_2,
            wea => wea_closed_list_2,
            addra => addra_closed_list_2,
            addrb => neighbor_2,
            dia => dia_closed_list_2,
            dob => dob_closed_list_2
        );

    closed_list_3: closed_list
        port map (
            clk => clk,
            ena => ena_closed_list_3,
            enb => enb_closed_list_3,
            wea => wea_closed_list_3,
            addra => addra_closed_list_3,
            addrb => neighbor_3,
            dia => dia_closed_list_3,
            dob => dob_closed_list_3
        );

    closed_list_4: closed_list
        port map (
            clk => clk,
            ena => ena_closed_list_4,
            enb => enb_closed_list_4,
            wea => wea_closed_list_4,
            addra => addra_closed_list_4,
            addrb => neighbor_4,
            dia => dia_closed_list_4,
            dob => dob_closed_list_4
        );

    -- Output the result
    out_data <= out_data_comp;
    output_data <= out_data;
    
    
    

    -- Toggle step and write '1' to closed_list when the output from the comparator changes
    process(clk, out_data_comp, start, reset)
    begin
        if reset = '1' then
            step <= '0';
            ena_closed_list_1 <= '0';
            wea_closed_list_1 <= '0';
            ena_closed_list_2 <= '0';
            wea_closed_list_2 <= '0';
            ena_closed_list_3 <= '0';
            wea_closed_list_3 <= '0';
            ena_closed_list_4 <= '0';
            wea_closed_list_4 <= '0';
            neighbor_1 <= (others => '1');
            neighbor_2 <= (others => '1');
            neighbor_3 <= (others => '1');
            neighbor_4 <= (others => '1');

        elsif rising_edge(clk) then
            if start = '1' then
                neighbor_1 <= std_logic_vector(unsigned(startpos) + 1);
                neighbor_2 <= std_logic_vector(unsigned(startpos) - 1);
                neighbor_3 <= std_logic_vector(unsigned(startpos) + 256);
                neighbor_4 <= std_logic_vector(unsigned(startpos) - 256);
            else 
                counter <= counter + 1;
            end if;
            if counter = "110" then
                if out_data_comp(31 downto 16) = endpos then
                    done <= '1';
                else
                    step <= not step;  -- Toggle step
                    ena_closed_list_1 <= '1';
                    wea_closed_list_1 <= '1';
                    ena_closed_list_2 <= '1';
                    wea_closed_list_2 <= '1';
                    ena_closed_list_3 <= '1';
                    wea_closed_list_3 <= '1';
                    ena_closed_list_4 <= '1';
                    wea_closed_list_4 <= '1';
                    addra_closed_list_1 <= out_data_comp(31 downto 16);
                    addra_closed_list_2 <= out_data_comp(31 downto 16);
                    addra_closed_list_3 <= out_data_comp(31 downto 16);
                    addra_closed_list_4 <= out_data_comp(31 downto 16);
                    dia_closed_list_1 <= "1";
                    dia_closed_list_2 <= "1";
                    dia_closed_list_3 <= "1";
                    dia_closed_list_4 <= "1";
                    read_addr <= out_data_comp(31 downto 16);
                    -- Find the neighbors of the current node where the first 8 bits are the x coordinate and the last 8 bits are the y coordinate
                    neighbor_1 <= std_logic_vector(unsigned(out_data_comp(31 downto 16)) + 1);
                    neighbor_2 <= std_logic_vector(unsigned(out_data_comp(31 downto 16)) - 1);
                    neighbor_3 <= std_logic_vector(unsigned(out_data_comp(31 downto 16)) + 256);
                    neighbor_4 <= std_logic_vector(unsigned(out_data_comp(31 downto 16)) - 256);
                end if;
                counter <= (others => '0');
            else
                ena_closed_list_1 <= '0';
                wea_closed_list_1 <= '0';
                ena_closed_list_2 <= '0';
                wea_closed_list_2 <= '0';
                ena_closed_list_3 <= '0';
                wea_closed_list_3 <= '0';
                ena_closed_list_4 <= '0';
                wea_closed_list_4 <= '0';
            end if;
            
        end if;
    end process;

end Behavioral;
