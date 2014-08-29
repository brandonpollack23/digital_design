library ieee;
use ieee.std_logic_1164.all;

entity cgen2 is
	port
	(
		ci : in std_logic;
		pi : in std_logic;
		gi : in std_logic;
		pi_n : in std_logic;
		gi_n : in std_logic;
		cout_in_between : out std_logic;
		cout : out std_logic;
		bp : out std_logic;
		bg : out std_logic
	);
end cgen2;

architecture arch of cgen2 is

begin
	process(ci,pi,gi,pi_n,gi_n)
	
	begin
		cout_in_between <= (ci and pi) or gi;
		cout <= (((ci and pi) or gi) and pi_n) or gi_n;
		
		bp <= pi_n and pi;
		bg <= (gi and pi_n) or (gi_n);
	end process;
end arch;