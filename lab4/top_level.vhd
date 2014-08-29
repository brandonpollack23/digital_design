library ieee;
use ieee.std_logic_1164.all;

entity top_level is
  port (
    clk50MHz      : in  std_logic;
    rst           : in  std_logic;
    dip_switch    : in  std_logic_vector(7 downto 0);
    clk_button_n  : in  std_logic;
    up_button_n   : in  std_logic;
    load_button_n : in  std_logic;
    led_hi        : out std_logic_vector(6 downto 0);
    led_lo        : out std_logic_vector(6 downto 0);
    led_dp_n      : out std_logic);
end top_level;

architecture STR of top_level is

  component decoder7seg
    port (
      input  : in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(6 downto 0));
  end component;

  component clk_gen
    generic (
      ms_period :     positive);
    port (
      clk50MHz  : in  std_logic;
      rst       : in  std_logic;
      button_n  : in  std_logic;
      clk_out   : out std_logic);
  end component;

  component gray2
    port (
      clk    : in  std_logic;
      rst    : in  std_logic;
      output : out std_logic_vector(3 downto 0));
  end component;

  component counter
    port (
      clk    : in  std_logic;
      rst    : in  std_logic;
      up_n   : in  std_logic;           -- active low
      load_n : in  std_logic;           -- active low
      input  : in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(3 downto 0));
  end component;

  constant MS_CLOCK_PERIOD : natural := 1000;

  signal gray_out    : std_logic_vector(3 downto 0);
  signal counter_out : std_logic_vector(3 downto 0);
  signal clk_gen_out : std_logic;

begin  -- STR

  U_GRAY : gray2 port map (
    clk    => clk_gen_out,
    rst    => rst,
    output => gray_out);

  U_COUNTER : counter port map (
    clk    => clk_gen_out,
    rst    => rst,
    up_n   => up_button_n,
    load_n => load_button_n,
    input  => dip_switch(3 downto 0),
    output => counter_out);

--U_quiz : entity work.quiz
--port map
--(
--	clk => clk_gen_out,
--	rst => rst,
--	x => up_button_n,
--	y => load_button_n,
--	output => counter_out
--);

  U_CLK_GEN : clk_gen
    generic map (
      ms_period => MS_CLOCK_PERIOD)
    port map (
      clk50MHz  => clk50MHz,
      rst       => rst,
      button_n  => clk_button_n,
      clk_out   => clk_gen_out);

  U_LED1_HI : decoder7seg port map (
    input  => gray_out,
    output => led_hi);

  U_LED_LO : decoder7seg port map (
    input  => counter_out,
    output => led_lo);

  led_dp_n <= '1';

end STR;
