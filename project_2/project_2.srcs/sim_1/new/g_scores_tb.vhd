library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tb_simple_dual_one_clock is
end tb_simple_dual_one_clock;

architecture tb_arch of tb_simple_dual_one_clock is
  signal clk : std_logic := '0';
  signal ena, enb, wea : std_logic := '0';
  signal addra, addrb : std_logic_vector(15 downto 0) := (others => '0');
  signal dia, dob : std_logic_vector(31 downto 0) := (others => '0');
  
  component simple_dual_one_clock
    port(
      clk : in std_logic;
      ena : in std_logic;
      enb : in std_logic;
      wea : in std_logic;
      addra : in std_logic_vector(15 downto 0);
      addrb : in std_logic_vector(15 downto 0);
      dia : in std_logic_vector(31 downto 0);
      dob : out std_logic_vector(31 downto 0)
    );
  end component;

begin
  -- Instantiate the DUT (Design Under Test)
  dut: simple_dual_one_clock
    port map(
      clk => clk,
      ena => ena,
      enb => enb,
      wea => wea,
      addra => addra,
      addrb => addrb,
      dia => dia,
      dob => dob
    );

  -- Clock generation process
  process
  begin
    while now < 1000 ns loop
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- Stimulus process
  process
  begin
    -- Initialize
    ena <= '1';
    enb <= '1';
    wea <= '1';
    addra <= (others => '0');
    addrb <= (others => '0');
    dia <= (others => '0');

    -- Write data to memory
    wait for 10 ns;
    wea <= '1';
    dia <= "00000000000000000000000000000001";  -- Data to be written
    wait for 10 ns;
    addra <= "0000000000000001";  -- Address to write data
    wait for 10 ns;

    -- Read data from memory
    wea <= '0';
    wait for 10 ns;
    addrb <= "0000000000000001";  -- Address to read data
    wait for 10 ns;

    -- Write data to memory
    wea <= '1';
    addra <= "0000000000000010";  -- Address to write data
    dia <= "00000000000000000000000000000010";  -- Data to be written
    wait for 10 ns;
    wea <= '0';
    wait for 10 ns;
    addrb <= "0000000000000010";  -- Address to read data
    wait for 20 ns;

  end process;

end tb_arch;
