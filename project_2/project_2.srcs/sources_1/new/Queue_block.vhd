library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity queue_block is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dequeue : in STD_LOGIC;
           to_temp_prev : out STD_LOGIC_VECTOR(31 downto 0);
           to_queue_prev : out STD_LOGIC_VECTOR(31 downto 0);
           from_temp_next : in STD_LOGIC_VECTOR(31 downto 0);
           from_queue_next : in STD_LOGIC_VECTOR(31 downto 0);
           temp_prev : in STD_LOGIC_VECTOR(31 downto 0);
           temp_next : out STD_LOGIC_VECTOR(31 downto 0));
end queue_block;

architecture Behavioral of queue_block is
    signal queue : STD_LOGIC_VECTOR(31 downto 0);
    signal temp : STD_LOGIC_VECTOR(31 downto 0);

begin
    process (clk, reset)
    begin
        if reset = '1' then
            -- Initialize queue and temp
            queue <= (others => '1');
            temp <= (others => '1');
        elsif rising_edge(clk) then            
            if dequeue = '1' then
                queue <= from_queue_next;
                temp <= from_temp_next;
            else
                -- Compare the last 16 bits of the data
                if temp_prev(15 downto 0) <= queue(15 downto 0) then
                    queue <= temp_prev;
                    temp <= queue;
                else
                    temp <= temp_prev;
                end if;
            end if;
        end if;
    end process;
     -- Assign the values to the output ports
    temp_next <= temp;
    to_temp_prev <= temp;
    to_queue_prev <= queue;
end Behavioral;
