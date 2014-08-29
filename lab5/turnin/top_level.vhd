library ieee;
use ieee.std_logic_1164.all;

entity top_level is
  port (
    clk50MHz      : in  std_logic;
    rst           : in  std_logic;
    x    : in  std_logic_vector(7 downto 0);
	 y		: in std_logic_vector(7 downto 0);
	 go_n	: in std_logic;
    led_hi        : out std_logic_vector(6 downto 0);
    led_lo        : out std_logic_vector(6 downto 0);
    led_dp_n      : out std_logic);
end top_level;

architecture STR of top_level is

signal go,led_dp : std_logic;
signal gcd_output : std_logic_vector(7 downto 0);

begin  -- STR
	go <= not go_n;
	led_dp_n <= not led_dp;
	
	U_GCD: entity work.gcd
	generic map
	(
		WIDTH => 8
	)
	port map
	(
		clk => clk50MHz,
		rst => rst,
		go => go,
		done => led_dp,
		x => x,
		y => y,
		output => gcd_output
	);

	U_LED1_HI : entity work.decoder7seg
	port map 
	(
		input  => gcd_output(7 downto 4),
		output => led_hi
	);

	U_LED_LO : entity work.decoder7seg 
	port map
	(
		input  => gcd_output(3 downto 0),
		output => led_lo
	);
	
	
end STR;
