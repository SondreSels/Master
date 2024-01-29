library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SmallestValueComparator is
    Port (
        clk : in std_logic;
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
end SmallestValueComparator;

architecture Behavioral of SmallestValueComparator is
    signal smallest_value : std_logic_vector(2 downto 0);
    signal comp_1_2 : std_logic_vector(31 downto 0);
    signal comp_3_4 : std_logic_vector(31 downto 0);
    signal result : std_logic_vector(31 downto 0);
    signal local_dequeue_1 : std_logic := '0';
    signal local_dequeue_2 : std_logic := '0';
    signal local_dequeue_3 : std_logic := '0';
    signal local_dequeue_4 : std_logic := '0';
    signal prev_step : std_logic := '0';
    
begin
    
    comp_1_2 <= input_1 when input_1(15 downto 0) < input_2(15 downto 0) else input_2;
    comp_3_4 <= input_3 when input_3(15 downto 0) < input_4(15 downto 0) else input_4;
    
    result <= comp_1_2 when comp_1_2(15 downto 0) < comp_3_4(15 downto 0) else comp_3_4;
    output_data <= result;

    dequeue_1 <= local_dequeue_1;
    dequeue_2 <= local_dequeue_2;
    dequeue_3 <= local_dequeue_3;
    dequeue_4 <= local_dequeue_4;
    process (step,clk)
    begin
        if rising_edge(clk) then  
            if step /= prev_step then
                if result = input_1 then
                    -- toggle dequeue_1
                    local_dequeue_1 <= not local_dequeue_1;
                elsif result = input_2 then
                    -- toggle dequeue_2
                    local_dequeue_2 <= not local_dequeue_2;
                elsif result = input_3 then
                    -- toggle dequeue_3
                    local_dequeue_3 <= not local_dequeue_3;
                elsif result = input_4 then
                    -- toggle dequeue_4
                    local_dequeue_4 <= not local_dequeue_4;
                end if;
                prev_step <= step;
            end if;
        end if;
    end process;
    

end Behavioral;
