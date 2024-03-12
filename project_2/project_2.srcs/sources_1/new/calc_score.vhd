library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity calc_score is
    Port ( 
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        closed : in  STD_LOGIC;
        new_pos : in  STD_LOGIC_VECTOR (15 downto 0);
        endpos : in  STD_LOGIC_VECTOR (15 downto 0);
        score_in : in  STD_LOGIC_VECTOR (15 downto 0);
        score_out : out  STD_LOGIC_VECTOR (15 downto 0);
        g_score_out : out  STD_LOGIC_VECTOR (15 downto 0);
        out_pos : out  STD_LOGIC_VECTOR (15 downto 0);
        cur_pos : in  STD_LOGIC_VECTOR (15 downto 0);
        came_from : out  STD_LOGIC_VECTOR (15 downto 0);
        this_dir : in STD_LOGIC;
        enqueue : out  STD_LOGIC
    );
end calc_score;

architecture Behavioral of calc_score is
    signal x : signed (7 downto 0);
    signal y : signed (7 downto 0);
    signal score : unsigned (15 downto 0) := (others => '0');
    signal prev_pos : std_logic_vector(15 downto 0) := (others => '1');
    signal prev_enqueue : std_logic := '0';
    signal do_enqueue_1 : std_logic := '0';
    signal do_enqueue_2 : std_logic := '0';
    signal do_enqueue_3 : std_logic := '0';
    signal temp_g_score : unsigned(15 downto 0) := (others => '0');
    

begin
    x <= abs(signed(new_pos(15 downto 8)) - signed(endpos(15 downto 8)));
    y <= abs(signed(new_pos(7 downto 0)) - signed(endpos(7 downto 0)));
    
    score <= temp_g_score + unsigned(x) + unsigned(y);
    temp_g_score <= (unsigned(score_in) + 1) when (this_dir = '1') else (unsigned(score_in) + 1);
    enqueue <= prev_enqueue;
    process(clk, reset)
    begin
        if reset = '1' then
            score_out <= (others => '0');
            prev_enqueue <= '0';
        elsif rising_edge(clk) then
            -- Calculate Manhattan distance and add it to score_in
            
            -- If new_pos is different from prev_pos, toggle enqueue
            if new_pos /= prev_pos then
                do_enqueue_1 <= '1';
                prev_pos <= new_pos;
            end if;
            if do_enqueue_1 = '1' then
                do_enqueue_1 <= '0';
                do_enqueue_2 <= '1';
            end if;
            if do_enqueue_2 = '1' then
                do_enqueue_2 <= '0';
                do_enqueue_3 <= '1';
            end if;
            if do_enqueue_3 = '1' then
                do_enqueue_3 <= '0';
                if closed = '0' then
                    score_out <= std_logic_vector(score);
                    g_score_out <= std_logic_vector(temp_g_score);
                    prev_enqueue <= not prev_enqueue;
                    out_pos <= prev_pos;
                    came_from <= cur_pos;
                end if;
            end if;
        end if;
    end process;


end Behavioral;

