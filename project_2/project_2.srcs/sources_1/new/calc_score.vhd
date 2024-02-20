library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity calc_score is
    Port ( 
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        last_pos : in  STD_LOGIC_VECTOR (15 downto 0);
        new_pos : in  STD_LOGIC_VECTOR (15 downto 0);
        endpos : in  STD_LOGIC_VECTOR (15 downto 0);
        score_in : in  STD_LOGIC_VECTOR (15 downto 0);
        score_out : out  STD_LOGIC_VECTOR (15 downto 0)
    );
end calc_score;

architecture Behavioral of calc_score is
    signal x : signed (15 downto 0);
    signal y : signed (15 downto 0);
    signal score : unsigned (15 downto 0);

begin
    x <= abs(signed(new_pos(15 downto 8)) - signed(endpos(15 downto 8)));
    y <= abs(signed(new_pos(7 downto 0)) - signed(endpos(7 downto 0)));
    
    score <= unsigned(score_in) + 1 + unsigned(x) + unsigned(y);

    process(clk, reset)
    begin
        if reset = '1' then
            score_out <= (others => '0');
        elsif rising_edge(clk) then
            -- Calculate Manhattan distance and add it to score_in
            score_out <= std_logic_vector(score);
        end if;
    end process;

end Behavioral;

