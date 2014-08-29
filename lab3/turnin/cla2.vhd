library ieee;
use ieee.std_logic_1164.all;

entity cla2 is
	port
	(
		x : in std_logic_vector(1 downto 0);
		y : in std_logic_vector(1 downto 0);
		cin : in std_logic;
		s : out std_logic_vector(1 downto 0);
		cout : out std_logic;
		bp : out std_logic;
		bg : out std_logic
	);
end cla2;

architecture arch of cla2 is

begin
	process(x,y,cin)	
	
	variable zero_to_one,g,p : std_logic;
	
	begin
		g := x(0) and y(0);
		p := (x(0) or y(0));
		zero_to_one := g or (p and cin);
		
		s(0) <= (x(0) xor y(0)) xor cin;
		s(1) <= (x(1) xor y(1)) xor zero_to_one;
		
		bg <= (x(1) and y(1)) or ((x(1) or y(1)) and g);
		bp <= (x(1) or y(1)) and p;
		
		cout <= (x(1) and y(1)) or (zero_to_one and (x(1) or y(1)));	
	end process;
end arch;
		
