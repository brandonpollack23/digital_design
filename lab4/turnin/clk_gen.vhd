library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_gen is
  generic (
    ms_period :     positive);          -- amount of ms for button to be
                                        -- pressed before creating clock pulse
  port (
    clk50MHz  : in  std_logic;
    rst       : in  std_logic;
    button_n  : in  std_logic;
    clk_out   : out std_logic);
end clk_gen;


architecture BHV of clk_gen is

signal clk1000hz : std_logic;
signal button : std_logic;

constant COUNTER_WIDTH : integer := integer(ceil(log2(real(ms_period)))) + 1; --add one so I have an extra bit (for ignoring first instance of when it should go true)
signal counter : unsigned(COUNTER_WIDTH-1 downto 0);

begin
	--button <= not button_n;
	
	CLK_DIV: entity work.clk_div
	generic map
	(
		clk_in_freq => 50e6,
		clk_out_freq => 1e3
	)
	port map
	(
		clk_in => clk50MHz,
		clk_out => clk1000hz,
		rst => rst
	);
	
	process(button,rst,clk1000hz)
	
	begin
		if(rst = '1' or button_n = '1') then --reset condition
			counter <= (others => '0');
			
		elsif(rising_edge(clk1000hz)) then			
			counter <= counter + 1;
			
			if(counter = ms_period + 1) then --overflow condition
			 counter <= to_unsigned(2,COUNTER_WIDTH);	
			end if;			
		end if;
		
	end process;

	process(counter, clk1000hz, button, rst)
	begin
		if(counter = ms_period + 1) then
			clk_out <= '1';
		else
			clk_out <= '0';
		end if;
	end process;
	
end BHV;