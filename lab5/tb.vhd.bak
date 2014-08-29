-- Greg Stitt
-- University of Florida
-- EEL 5934/4930 Reconfigurable Computing
--
-- File: tb.vhd
--
-- Description: This file implements a simple testbench for the Fibonacci
-- calculator. Note that this entity uses std_logic_arith in order to
-- illustrate a different package. I highly recommend using numeric_std
-- instead.   
--
-- Comments: Ideally, the individual tests could be made into a procedure to
-- avoid copy and pasting.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tb is
end tb;

architecture behavior of tb is

  component FIB
    generic (width :     positive := 32);
    port( clk      : in  std_logic;
          rst      : in  std_logic;
          go       : in  std_logic;
          n        : in  std_logic_vector(width-1 downto 0);
          result   : out std_logic_vector(width-1 downto 0);
          done     : out std_logic );
  end component;

  --Inputs
  signal clk : std_logic                     := '0';
  signal rst : std_logic                     := '1';
  signal go  : std_logic                     := '0';
  signal n   : std_logic_vector(31 downto 0) := (others => '0');

  --Outputs
  signal result : std_logic_vector(31 downto 0);
  signal done   : std_logic;

begin

  uut : FIB
    generic map (32)
    port map(clk, rst, go, n, result, done);

  -- toggle clock
  clk <= not clk after 5 ns;

  -- process to test different inputs
  process
  begin

    -- reset circuit  
    rst <= '1';
    wait for 200 ns;
    rst <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    ---------------------------------------------------------------------------
    -- test n = 1
    ---------------------------------------------------------------------------

    n  <= conv_std_logic_vector(1, 32);
    go <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    go <= '1';

    wait until done = '1';              -- assumes done will eventually be 1
    assert (result = conv_std_logic_vector(1, 32)) report "Result for n = 1 incorrect" severity error;
    wait until clk'event and clk = '1';

    ---------------------------------------------------------------------------
    -- test n = 2
    ---------------------------------------------------------------------------

    n  <= conv_std_logic_vector(2, 32);
    go <= '0';
    wait until clk'event and clk = '1';
    go <= '1';

    wait until done = '1';
    assert (result = conv_std_logic_vector(1, 32)) report "Result for n = 2 incorrect" severity error;
    wait until clk'event and clk = '1';

    ---------------------------------------------------------------------------
    -- test n = 3
    ---------------------------------------------------------------------------

    n  <= conv_std_logic_vector(3, 32);
    go <= '0';
    wait until clk'event and clk = '1';
    go <= '1';

    wait until done = '1';
    assert (result = conv_std_logic_vector(2, 32)) report "Result for n = 2 incorrect" severity error;
    wait until clk'event and clk = '1';

    ---------------------------------------------------------------------------
    -- test n = 4
    ---------------------------------------------------------------------------

    n  <= conv_std_logic_vector(4, 32);
    go <= '0';
    wait until clk'event and clk = '1';
    go <= '1';

    wait until done = '1';
    assert (result = conv_std_logic_vector(3, 32)) report "Result for n = 3 incorrect" severity error;
    wait until clk'event and clk = '1';

    ---------------------------------------------------------------------------
    -- test n = 5
    ---------------------------------------------------------------------------

    n  <= conv_std_logic_vector(5, 32);
    go <= '0';
    wait until clk'event and clk = '1';
    go <= '1';

    wait until done = '1';
    assert (result = conv_std_logic_vector(5, 32)) report "Result for n = 4 incorrect" severity error;
    wait until clk'event and clk = '1';

    ---------------------------------------------------------------------------
    -- test n = 6
    ---------------------------------------------------------------------------

    n  <= conv_std_logic_vector(6, 32);
    go <= '0';
    wait until clk'event and clk = '1';
    go <= '1';

    wait until done = '1';
    assert (result = conv_std_logic_vector(8, 32)) report "Result for n = 5 incorrect" severity error;
    wait until clk'event and clk = '1';

    ---------------------------------------------------------------------------
    -- test n = 26
    ---------------------------------------------------------------------------

    n  <= conv_std_logic_vector(26, 32);
    go <= '0';
    wait until clk'event and clk = '1';
    go <= '1';

    wait until done = '1';
    assert (result = conv_std_logic_vector(121393, 32)) report "Result for n = 26 incorrect" severity error;
    wait until clk'event and clk = '1';

    wait;
  end process;

end;
