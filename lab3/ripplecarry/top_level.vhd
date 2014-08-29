library ieee;
use ieee.std_logic_1164.all;

entity top_level is
  port (
    dip_switch1 : in  std_logic_vector(7 downto 0);
    dip_switch2 : in  std_logic_vector(7 downto 0);
    cin_button  : in  std_logic;
    led_hi      : out std_logic_vector(6 downto 0);
    led_hi_dp   : out std_logic;
    led_lo      : out std_logic_vector(6 downto 0);
    led_lo_dp   : out std_logic);
end top_level;

architecture STR of top_level is

  component decoder7seg
    port (
      input  : in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(6 downto 0));
  end component;

  component adder
    generic (
      WIDTH :     positive := 8);
    port (
      x, y  : in  std_logic_vector(WIDTH-1 downto 0);
      cin   : in  std_logic;
      s     : out std_logic_vector(WIDTH-1 downto 0);
      cout  : out std_logic);
  end component;

  signal s    : std_logic_vector(7 downto 0);
  signal cout : std_logic;

begin  -- STR

  U_LED1_HI : decoder7seg port map (
    input  => s(7 downto 4),
    output => led_hi);

  U_LED_LO : decoder7seg port map (
    input  => s(3 downto 0),
    output => led_lo);

  U_ADDER : adder
    generic map (
      WIDTH => 8)
    port map (
      x     => x"FF",
      y     => x"00",
      cin   => cin_button,
      s     => s,
      cout  => cout);

  led_hi_dp <= cout;
  led_lo_dp <= cin_button;

end STR;


configuration top_level_cfg of top_level is
  for STR
    for U_ADDER : adder
      use entity work.adder(HIERARCHICAL);  -- change this line for other
                                            -- architectures 
    end for;
  end for;
end top_level_cfg;
