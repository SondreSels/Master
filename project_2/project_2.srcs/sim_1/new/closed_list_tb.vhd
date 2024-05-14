library IEEE;
use IEEE.std_logic_1164.all;

entity testbench_closed_list is
end testbench_closed_list;

architecture behavior of testbench_closed_list is
    -- Component Declaration for the BRAM
    component closed_list
    port(
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
    
    -- Testbench Signals
    signal clk_tb, ena_tb, enb_tb, wea_tb : std_logic := '0';
    signal dia_tb, dob_tb : std_logic_vector(0 downto 0);
    signal addra_tb, addrb_tb : std_logic_vector(15 downto 0);
    
begin

    -- Instantiate the BRAM
    uut : closed_list
    port map (
        clk => clk_tb,
        ena => ena_tb,
        enb => enb_tb,
        wea => wea_tb,
        addra => addra_tb,
        addrb => addrb_tb,
        dia => dia_tb,
        dob => dob_tb
    );
    
    -- Clock process
    clk_process : process
    begin
        while now < 1000 ns loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
    
    -- Stimulus process
    stim_proc : process
    begin
        -- Enable write (ena) and address for write (addra)
        wait for 100 ns;
        ena_tb <= '1';
        wea_tb <= '1';
        addra_tb <= "0000000000000010"; -- Example address for write
        dia_tb <= "1"; -- Example data for write
        wait for 20 ns;
        
        -- Enable read (enb) and address for read (addrb)
        enb_tb <= '1';
        addrb_tb <= "0000000000000001"; -- Example address for read
        wait for 20 ns;
        addrb_tb <= "0000000000000010";
        wait for 20 ns;
        addrb_tb <= "0000000000000001";
        wait for 20 ns;

        addra_tb <= "0000000000000001"; -- Example address for write
        wait for 20 ns;

        addrb_tb <= "0000000000000010"; -- Example address for read
        wait for 20 ns;
        addrb_tb <= "0000000000000001"; -- Example address for read
        wait for 20 ns;

        addrb_tb <= "0000000000000010";
        
        -- Display the read data
        
        wait;
    end process;

end behavior;
