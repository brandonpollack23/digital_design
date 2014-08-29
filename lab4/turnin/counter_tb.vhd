library ieee;
use ieee.std_logic_1164.all;

entity counter_tb is
end counter_tb;

architecture TB of counter_tb is

signal clk : std_logic := '0';
signal rst : std_logic;
signal input : std_logic_vector(3 downto 0);
signal output : std_logic_vector(3 downto 0);

signal up_n : std_logic;
signal load_n : std_logic;

signal done : std_logic := '0';

begin
	
	U_gray1: entity work.counter
	port map
	(
		clk => clk,
		rst => rst,
		output => output,
		up_n => up_n,
		load_n => load_n,
		input => input
	);
	
	clk <= not clk and not done after 10ns;
	
	process
	begin
		
		rst <= '1';
		wait for 20 ns;
		
		rst <= '0';
		up_n <= '0'; --first count up
		load_n <= '1'; --do not load 
		
		for i in 0 to 15 loop
			wait until rising_edge(clk);
		end loop;
		
		wait for 5ns;
		
		load_n <= '0'; --load a value
		input <= "1010";
		
		wait until rising_edge(clk);
		
		up_n <= '1'; --count down
		load_n <= '1';
		
		for i in 0 to 15 loop
			wait until rising_edge(clk);
		end loop;
		
		rst <= '0';
		done <= '1';		
		
		wait;
		
	end process;
end TB;