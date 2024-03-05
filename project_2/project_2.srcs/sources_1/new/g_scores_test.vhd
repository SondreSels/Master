library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity g_scores is
 port(
 clk : in std_logic;
 enb : in std_logic;
 wea : in std_logic;
 addra : in std_logic_vector(15 downto 0);
 addrb : in std_logic_vector(15 downto 0);
 dia : in std_logic_vector(31 downto 0);
 dob : out std_logic_vector(31 downto 0)
 );
end g_scores;
architecture syn of g_scores is
 type ram_type is array (65535 downto 0) of std_logic_vector(31 downto 0);
 shared variable RAM : ram_type := (others => (others => '0'));
begin
 process(clk)
 begin
 if clk'event and clk = '1' then
 if wea = '1' then
 RAM(conv_integer(addra)) := dia;
 end if;
 end if;
 end process;
 process(clk)
 begin
 if clk'event and clk = '1' then
 if enb = '1' then
 dob <= RAM(conv_integer(addrb));
 end if;
 end if;
 end process;
end syn;