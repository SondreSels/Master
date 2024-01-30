library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity g_scores is
    PORT (
        clk : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        enb : IN STD_LOGIC;
        addrb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
      );
end g_scores;

architecture Behavioral of g_scores is
------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
    component blk_mem_gen_0
      PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        addrb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
      );
    end component;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
begin
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
    g_scores : blk_mem_gen_0
      PORT MAP (
        clka => clk,
        ena => ena,
        wea => wea,
        addra => addra,
        dina => dina,
        clkb => clk,
        enb => enb,
        addrb => addrb,
        doutb => doutb
      );
      
end Behavioral;
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file blk_mem_gen_0.vhd when simulating
-- the core, blk_mem_gen_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.



