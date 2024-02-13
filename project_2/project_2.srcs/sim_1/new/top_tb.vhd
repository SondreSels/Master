library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Testbench is
end Testbench;

architecture Sim of Testbench is
    -- Signals for Testbench
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal in_data_1, in_data_2, in_data_3, in_data_4 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal enqueue_1, enqueue_2, enqueue_3, enqueue_4 : STD_LOGIC := '0';
    signal out_data : STD_LOGIC_VECTOR(31 downto 0);
    signal ena_g_scores, enb_g_scores, wea_g_scores : STD_LOGIC := '0';
    signal addra_g_scores, addrb_g_scores : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal dob_g_scores, dia_g_scores : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal dob_closed_list : STD_LOGIC_VECTOR(0 downto 0) := "0";

    

    -- Instantiate the DUT (Design Under Test)
    component TopModule
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
            addra_g_scores : in STD_LOGIC_VECTOR(15 downto 0);
            addrb_g_scores : in STD_LOGIC_VECTOR(15 downto 0);
            dia_g_scores : in STD_LOGIC_VECTOR(31 downto 0);
            dob_g_scores : out STD_LOGIC_VECTOR(31 downto 0);
            dob_closed_list : out STD_LOGIC_VECTOR(0 downto 0)
        );
    end component;

    -- Stimulus process
    begin
    -- Instantiate the DUT
    DUT: TopModule port map (
        clk => clk,
        reset => reset,
        in_data_1 => in_data_1,
        in_data_2 => in_data_2,
        in_data_3 => in_data_3,
        in_data_4 => in_data_4,
        enqueue_1 => enqueue_1,
        enqueue_2 => enqueue_2,
        enqueue_3 => enqueue_3,
        enqueue_4 => enqueue_4,
        out_data => out_data,
        ena_g_scores => ena_g_scores,
        enb_g_scores => enb_g_scores,
        wea_g_scores => wea_g_scores,
        addra_g_scores => addra_g_scores,
        addrb_g_scores => addrb_g_scores,
        dia_g_scores => dia_g_scores,
        dob_g_scores => dob_g_scores,
        dob_closed_list => dob_closed_list
    );
    -- Clock process
    process
    begin
        while now < 500 ns loop
            clk <= not clk;
            wait for 5 ns;
        end loop;
        wait;
    end process;
    process
    begin
        reset <= '1'; -- Reset active
        wait for 10 ns;
        reset <= '0'; -- De-assert reset
        wait for 100 ns;

        -- Provide some input data
        in_data_1 <= "00100000000000000000000000001111";
        in_data_2 <= "00001000000000000000000000111100";
        in_data_3 <= "01000000000000000000000011110000";
        in_data_4 <= "00000100000000000000001111000000";
        enqueue_1 <= '1';
        enqueue_2 <= '1';
        enqueue_3 <= '1';
        enqueue_4 <= '1';

        wait for 100 ns;
        

        -- Add more stimulus or assertions as needed

        wait;
    end process;

    

end Sim;
