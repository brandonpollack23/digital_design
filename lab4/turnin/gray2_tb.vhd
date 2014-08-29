library ieee;
use ieee.std_logic_1164.all;

entity gray2_tb is
end gray2_tb;

architecture TB of gray2_tb is

signal clk : std_logic := '0';
signal rst : std_logic;
signal output : std_logic_vector(3 downto 0);

signal done : std_logic := '0';

begin
	
	U_gray1: entity work.gray2
	port map
	(
		clk => clk,
		rst => rst,
		output => output
	);
	
	clk <= not clk and not done after 10ns;
	
	process
	begin
		
		rst <= '1';
		wait for 20 ns;
		
		rst <= '0';
		
		for i in 0 to 15 loop
			wait until rising_edge(clk);
		end loop;
		
		wait for 5ns;
		
		rst <= '0';
		done <= '1';		
		
		wait;
		
	end process;
end TB;